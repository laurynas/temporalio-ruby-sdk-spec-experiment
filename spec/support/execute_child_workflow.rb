class ExecuteChildWorkflow < Temporalio::Workflow::Definition
  def execute(name = 'World')
    Temporalio::Workflow.execute_child_workflow(
      HelloWorkflow,
      name,
    )
  end
end
