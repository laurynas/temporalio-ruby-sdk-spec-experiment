class HelloActivity < Temporalio::Activity::Definition
  def execute(name = 'World')
    "Hello, #{name}!"
  end
end
