require 'erb'
require 'ostruct'

class Template
  attr_reader :path, :erb

  def initialize(template_path)
    @path = template_path
    @erb = ERB.new(File.read(template_path), trim_mode: '-')
  end

  def filename
    File.basename(path)
  end

  def render(values)
    TemplateRenderer.new(self, TemplateMethods.new(values))
  end

  def self.render_into_dockerfile(path, values)
    new(path).render(values).to_string
  end

  class TemplateMethods
    def initialize(values)
      @root_path_included = false
      @source = OpenStruct.new(values)
    end

    def method_missing(method, *args, &block)
      @source.send(method, *args, &block)
    end

    def from_image(base_image)
      image_name = base_image.is_a?(Hash) ? base_image['name'] : base_image
      image_source = base_image.is_a?(Hash) ? base_image['source'] : nil

      use_root_path = image_source != 'dockerhub' && !@root_path_included
      image_path = use_root_path ? "${ROOT_PATH}/#{image_name}" : image_name

      res = ""
      res << "ARG ROOT_PATH=instructure\n" if use_root_path
      res << "FROM #{image_path}"

      @root_path_included ||= true
      res
    end
  end

  class TemplateRenderer
    def initialize(template, context)
      @template = template
      @context = context
    end

    def to(output_dir)
      output_path = File.join(output_dir, @template.filename)
      IO.write(output_path, to_string)
    end

    def to_string
      @template.erb.result(@context.instance_eval { binding })
    end
  end
end
