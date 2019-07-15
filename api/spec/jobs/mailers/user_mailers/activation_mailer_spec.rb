describe Mailers::UserMailers::ActivationMailer do
  describe '#deliver' do
    it 'should enqueue' do
      new_user = build :user

      queue_name = 'mailers.user.activation'
      payload = {
        email: new_user.email,
        activation_link: nil
      }

      expect(Job).to receive(:enqueue).with(queue: queue_name, payload: payload)

      Mailers::UserMailers::ActivationMailer.new(new_user).deliver
    end
  end
end