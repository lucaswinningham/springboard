RSpec.describe User, type: :model do
  describe '#create' do
    it 'should send activation mail' do
      new_user = build :user
      mailer = double

      allow(Mailers::UserMailers::ActivationMail).to receive(:new).with(new_user) { mailer }
      allow(mailer).to receive(:deliver)

      new_user.save
    end
  end
end
