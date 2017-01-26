require 'erb'
require 'ostruct'

task default: 'generate:all'

PROJECT_DIR = File.dirname(__FILE__)
RUBY_VERSIONS = %w{2.1 2.2 2.3 2.4}.map(&:freeze).freeze
BUNDLER_VERSION = '1.12.5'.freeze

generation_erb = ERB.new("# GENERATED FILE, DO NOT MODIFY!\n# To update this file please edit the relevant template (<%= template_path %>)\n# and run the generation task `<%= task_name.nil? ? 'rake generate:all' : \"rake \#{task_name}\" %>`\n")
class GenerationMessage
  attr_reader :template_path, :task_name
  def initialize(template_path, task_name = nil)
    @template_path = template_path
    @task_name = task_name
  end
end

generation_erb.def_method(GenerationMessage, 'render')

namespace :generate do
  desc 'Generate all Ruby base Dockerfiles'
  task :ruby do |t|
    puts "Generating \e[31mRuby\e[0m Dockerfiles"
    generation_message = GenerationMessage.new('ruby/Dockerflie.template.erb', t.name).render
    template = ERB.new(File.read(File.expand_path('ruby/Dockerfile.template.erb', PROJECT_DIR)))

    RUBY_VERSIONS.each do |version|
      print "- #{version}... "
      output_dir = File.join(PROJECT_DIR, 'ruby', version)
      output_path = File.join(output_dir, 'Dockerfile')
      variable_container = OpenStruct.new(generated_message: generation_message, ruby_version: version, bundler_version: BUNDLER_VERSION)
      Dir.mkdir(output_dir) unless Dir.exist?(output_dir)
      File.open(output_path, File::WRONLY|File::CREAT|File::TRUNC) do |f|
        f.write(template.result(variable_container.instance_eval { binding }))
      end
      puts "Done!"
    end
  end

  # This one must be last for the dependency resolution magic to work
  desc 'Generate all templatized Dockerfiles'
  task 'all' => Rake.application.tasks.select{|t| t.name.start_with?('generate') }.map(&:name)
end
