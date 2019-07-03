RSpec.describe User, type: :model do
  it 'should populate salt on create' do
    user = create :user, salt: nil
    expect(user.salt).to be_present
  end

  describe '#refresh_auth' do
    it 'should refresh relevant auth fields' do
      user = create :user

      expect(user.nonce).to be_nil
      expect(user.ckey).to be_nil
      expect(user.civ).to be_nil
      expect(user.auth_expires_at).to be_nil

      user.refresh_auth

      expect(user.nonce).to be_present
      expect(user.ckey).to be_present
      expect(user.civ).to be_present
      expect(user.auth_expires_at).to be_present
    end
  end
end
