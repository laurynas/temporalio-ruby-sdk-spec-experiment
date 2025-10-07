# frozen_string_literal: true

RSpec.describe 'temporalio experiments' do
  let(:temporalio_worker) do
    Temporalio::Worker.new(
      client: temporalio_client,
      task_queue: task_queue,
      workflows: temporalio_workflows,
      activities: temporalio_activities,
    )
  end

  let(:task_queue) { 'default' }
  let(:temporalio_workflows) { [HelloWorkflow, ExecuteActivityWorkflow, ExecuteChildWorkflow] }
  let(:temporalio_activities) { [HelloActivity] }
  let(:temporalio_client) { temporalio_workflow_env.client }
  let(:temporalio_workflow_env) { Temporalio::Testing::WorkflowEnvironment.start_time_skipping }

  after { temporalio_workflow_env.shutdown }

  it 'executes workflow' do
    temporalio_worker.run do
      result = temporalio_client.execute_workflow(
        HelloWorkflow,
        'Alice',
        id: 'test',
        task_queue: task_queue,
      )
      expect(result).to eq('Hello, Alice!')
    end
  end

  it 'executes workflow with activity' do
    temporalio_worker.run do
      result = temporalio_client.execute_workflow(
        ExecuteActivityWorkflow,
        'Alice',
        id: 'test',
        task_queue: task_queue,
      )
      expect(result).to eq('Hello, Alice!')
    end
  end

  it 'executes workflow with child workflow' do
    temporalio_worker.run do
      result = temporalio_client.execute_workflow(
        ExecuteChildWorkflow,
        'Alice',
        id: 'test',
        task_queue: task_queue,
      )
      expect(result).to eq('Hello, Alice!')
    end
  end

  context 'with activity stubbing' do
    before do
      allow_any_instance_of(HelloActivity).to receive(:execute).and_return('Hello, Bob!')
    end

    it 'executes workflow with activity' do
      temporalio_worker.run do
        result = temporalio_client.execute_workflow(
          ExecuteActivityWorkflow,
          'Alice',
          id: 'test',
          task_queue: task_queue,
        )
        expect(result).to eq('Hello, Bob!')
      end
    end
  end

  context 'with workflow stubbing' do
    before do
      allow_any_instance_of(HelloWorkflow).to receive(:execute).and_return('Hello, Bob!')
    end

    it 'executes workflow with activity' do
      temporalio_worker.run do
        result = temporalio_client.execute_workflow(
          ExecuteChildWorkflow,
          'Alice',
          id: 'test',
          task_queue: task_queue,
        )
        expect(result).to eq('Hello, Bob!')
      end
    end
  end
end
