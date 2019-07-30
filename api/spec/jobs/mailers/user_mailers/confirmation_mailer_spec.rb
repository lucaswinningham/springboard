describe Mailers::UserMailers::ConfirmationMailer do
  describe '#deliver' do
    it 'should enqueue' do
      new_user = build :user

      queue_name = 'mailers.user.confirmation'

      link = "#{ENV['CLIENT_URL']}/activate/#{new_user.name}/#{new_user.confirmation_token}"
      payload = { email: new_user.email, confirmation_link: link }

      expect(Job).to receive(:enqueue).with(queue: queue_name, payload: payload)

      Mailers::UserMailers::ConfirmationMailer.new(new_user).deliver
    end
  end
end
