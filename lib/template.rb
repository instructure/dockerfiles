require 'erb'
require 'ostruct'

class Template
  attr_reader :path, :erb
  def initialize(template_path)
    @path = template_path
    @erb = ERB.new(File.read(template_path), nil, '-')
  end

  def filename
    File.basename(path)
  end

  def render(values)
    TemplateRenderer.new(self, OpenStruct.new(values))
  end

  def self.render_into_dockerfile(path, values)
    new(path).render(values).to_string
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
