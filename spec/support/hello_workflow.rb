class HelloWorkflow < Temporalio::Workflow::Definition
  def execute(name = 'World')
    "Hello, #{name}!"
  end
end
