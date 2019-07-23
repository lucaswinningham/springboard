describe Job do
  describe '::enqueue' do
    context 'when not in test environment' do
      before do
        expect(Rails.env).to receive(:test?) { false }
      end

      it 'should enqueue' do
        queue_name = 'test'
        payload = { hello: 'world' }

        connection = double 'connection'
        channel = double 'channel'
        queue = double 'queue'

        expect(Bunny).to receive(:new) { connection }
        expect(connection).to receive(:start)
        expect(connection).to receive(:create_channel) { channel }
        expect(channel).to receive(:queue).with(queue_name, durable: true) { queue }
        expect(queue).to receive(:publish).with(payload.to_json)
        expect(connection).to receive(:close)

        Job.enqueue queue: queue_name, payload: payload
      end
    end

    context 'when in test environment' do
      it 'should not enqueue' do
        expect(Bunny).not_to receive(:new)
        Job.enqueue
      end
    end
  end
end
