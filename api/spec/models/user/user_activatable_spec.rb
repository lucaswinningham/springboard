RSpec.describe User, type: :model do
  describe '#create' do
    it 'should #refresh_activation' do
      new_user = build :user
      expect(new_user).to receive(:refresh_activation)
      new_user.save
    end
  end

  describe '#refresh_activation' do
    it 'should set #activation_token' do
      new_token = 'new_activation_token'
      expect(SecureRandom).to receive(:hex) { new_token }
      user = create :user
      expect(user.activation_token).to eq new_token
    end

    it 'should populate activation_digest' do
      new_digest = 'new_activation_digest'
      new_token = 'new_activation_token'
      expect(SecureRandom).to receive(:hex) { new_token }
      expect(BCrypt::Password).to receive(:create).with(new_token) { new_digest }
      user = create :user, activation_digest: nil
      expect(user.activation_digest).to eq new_digest
    end
  end

  describe '#deactivate' do
    it 'should deactivate associations' do
    end
  end
end
