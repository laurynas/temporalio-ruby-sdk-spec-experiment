class ExecuteActivityWorkflow < Temporalio::Workflow::Definition
  def execute(name = 'World')
    Temporalio::Workflow.execute_activity(
      HelloActivity,
      name,
      start_to_close_timeout: 1.0,
    )
  end
end
