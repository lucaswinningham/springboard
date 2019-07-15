RSpec.describe User, type: :model do
  describe '#create' do
    it 'should send activation mail' do
      new_user = build :user
      mailer = double 'user_activation_mailer'

      expect(Mailers::UserMailers::ActivationMailer).to receive(:new).with(new_user) { mailer }
      expect(mailer).to receive(:deliver)

      new_user.save
    end
  end

  describe '#save' do
    it 'subsequent saves should not send activation mail' do
      existing_user = create :user

      expect(Mailers::UserMailers::ActivationMailer).not_to receive(:new)

      existing_user.save
    end
  end
end
