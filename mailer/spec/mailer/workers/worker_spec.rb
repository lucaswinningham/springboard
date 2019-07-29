require 'mailer/workers/worker'

class WorkerDouble
  include Worker

  attr_reader :my_attr

  def go
    @my_attr = payload.my_attr
  end
end

class NoGoWorkerDouble
  include Worker
end

RSpec.describe Worker do
  let(:my_attr) { 'my_attr' }
  let(:payload) { { my_attr: my_attr } }
  let(:message) { payload.to_json }

  context 'given a correctly implemented worker' do
    subject { WorkerDouble.new }

    it 'should respond to #go' do
      expect(subject).to respond_to :go
    end

    it 'should expect a payload' do
      expect { subject.work message }.to change { subject.payload }.to OpenStruct.new payload
    end

    it 'should run #go' do
      expect { subject.work message }.to change { subject.my_attr }.to my_attr
    end
  end

  context 'given a worker implemented without #go' do
    subject { NoGoWorkerDouble.new }

    it 'should raise an error' do
      expect{ subject.work message }.to raise_error NotImplementedError
    end
  end
end
