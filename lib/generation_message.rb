require 'erb'

GENERATION_MESSAGE_TEMPLATE = <<-EOF
# GENERATED FILE, DO NOT MODIFY!
# To update this file please edit the relevant template and run the generation
# task `<%= task_name.nil? ? 'rake generate:all' : \"rake \#{task_name}\" %>`
EOF

class GenerationMessage
  attr_reader :task_name
  def initialize(task_name = nil)
    @task_name = task_name
  end
end

ERB.new(GENERATION_MESSAGE_TEMPLATE).def_method(GenerationMessage, 'render')
