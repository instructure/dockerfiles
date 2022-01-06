# STDLIB stuffs
require 'fileutils'
require 'yaml'
require 'pathname'

# Local stuffs
require_relative 'lib/generation_message'
require_relative 'lib/template'

task default: 'generate:all'

PROJECT_DIR = File.dirname(__FILE__)
PROJECT_PATHNAME = Pathname.new(PROJECT_DIR)
MANIFEST = YAML.load_file(File.join(PROJECT_DIR, 'manifest.yml'), aliases: true)
TESTING_PARALLELIZATION = 5

def build_output_path(*parts)
  File.join(PROJECT_DIR, *parts)
end

def build_template_dir(image_name)
  File.join(image_name, 'template')
end

def with_clean_output_dir(*path_parts)
  output_dir = build_output_path(*path_parts)
  FileUtils.rm_r(output_dir) if File.exist?(output_dir)
  FileUtils.mkdir_p(output_dir)
  yield output_dir
end
namespace :ci do
  desc 'Generate index of Dockerfiles'
  task 'index' do
    dockerfiles = Dir.glob(File.join(PROJECT_DIR, '**', 'Dockerfile')).reject do |path|
      path.include?('template') ||
        path.include?('ci') ||
        path.include?('deprecated') ||
        path.include?('appliances')
    end

    docker_contexts = dockerfiles.map do |path|
      Pathname.new(path).relative_path_from(PROJECT_PATHNAME).dirname
    end

    split_size = (docker_contexts.size / TESTING_PARALLELIZATION.to_f).ceil
    n = 0
    docker_contexts.sort.each_slice(split_size) do |contexts|
      File.open("ci/dockerfiles_#{n}.yml", 'w') { |f| f.write(contexts.sort.map(&:to_s).to_yaml) }
      n += 1
    end
  end
end

namespace :generate do
  MANIFEST.each do |image_name, details|
    desc "Generate all #{image_name} Dockerfiles"
    task image_name do |t|
      puts "Generating #{image_name} Dockerfiles"
      template_dir = build_template_dir(image_name)
      generation_message = GenerationMessage.new(t.name).render

      template_filenames = details.fetch('template_files') { [] }
      template_filenames << 'Dockerfile' unless template_filenames.include?('Dockerfile')
      templates = template_filenames.map { |filename| Template.new(File.join(template_dir, filename)) }

      defaults = details.fetch('defaults', {})
      details['versions'].each do |version, values|
        print "- #{version}... "
        values ||= {}
        with_clean_output_dir(image_name, version) do |output_dir|
          version = values['version_override'] if values['version_override']
          template_values = defaults
                            .merge(values)
                            .merge(
                              generation_message: generation_message,
                              version: version
                            )
          templates.each do |template|
            template.render(template_values).to(output_dir)
          end
          files_to_copy = Dir.glob(File.join(template_dir, '**')).reject do |path|
            templates.any? { |template| File.identical?(path, template.path) }
          end
          FileUtils.cp_r(files_to_copy, output_dir, preserve: true)
        end
        puts 'Done!'
      end
    end
  end

  # This one must be last for the dependency resolution magic to work
  desc 'Generate all templatized Dockerfiles'
  task 'all' => Rake.application.tasks.select { |t| t.name.start_with?('generate') }.map(&:name)
end
