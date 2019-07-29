require 'mailer/workers/worker'

class WorkerDouble
  include Worker

  def go; end
end

class NoGoWorkerDouble
  include Worker
end

RSpec.describe Worker do
  let(:payload) { { hello: 'world' } }
  let(:message) { payload.to_json }

  context 'given a correctly implemented worker' do
    subject { WorkerDouble.new }

    it 'should respond to #go' do
      expect(subject).to respond_to :go
    end

    it 'should expect a payload' do
      expect { subject.work message }.to change { subject.payload }.to OpenStruct.new payload
    end
  end

  context 'given a worker implemented without #go' do
    subject { NoGoWorkerDouble.new }

    it 'should raise an error' do
      expect{ subject.work message }.to raise_error NotImplementedError
    end
  end
end
