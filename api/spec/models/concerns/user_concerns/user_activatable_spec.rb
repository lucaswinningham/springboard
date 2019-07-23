RSpec.describe User, type: :model do
  describe '#trigger_activation' do
    context 'on create' do
      it 'should be called' do
        new_user = build :user
        expect(new_user).to receive(:trigger_activation)
        new_user.save
      end
    end

    it 'should set #activation_token' do
      user = create :user
      new_token = 'new_activation_token'

      expect(SecureRandom).to receive(:hex) { new_token }
      expect { user.trigger_activation }.to change { user.activation_token }.to new_token
    end

    it 'should populate activation_digest with hashed #activation_token' do
      user = create :user, activation_digest: nil
      new_digest = 'new_activation_digest'
      new_token = 'new_activation_token'

      expect(SecureRandom).to receive(:hex) { new_token }
      expect(BCrypt::Password).to receive(:create).with(new_token) { new_digest }
      expect { user.trigger_activation }.to change { user.activation_digest }.to new_digest
    end

    it 'should send activation mail' do
      new_user = build :user

      mailer = Mailers::UserMailers::ActivationMailer.new(new_user)
      expect(Mailers::UserMailers::ActivationMailer).to receive(:new).with(new_user) { mailer }
      expect(mailer).to receive(:deliver)

      new_user.save
    end
  end

  describe '#deactivate' do
    it 'should deactivate associations' do
    end
  end
end
