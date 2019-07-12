RSpec.describe User, type: :model do
  describe '#create' do
    it 'should populate salt on create' do
      new_salt = 'new_salt'
      allow(BCrypt::Engine).to receive(:generate_salt) { new_salt }
      user = create :user, salt: nil
      expect(user.salt).to eq new_salt
    end
  end

  describe '#save' do
    it 'subsequent saves should not change salt' do
      user = create :user
      expect { user.update salt: 'bogus' }.to_not change { user.reload.salt }.itself
    end
  end

  describe '#refresh_auth' do
    it 'should populate nonce' do
      nonce_re = Regexp.new ''
      user = create :user
      expect { user.refresh_auth }.to change { user.nonce }.to(nonce_re)
    end

    it 'should populate ckey' do
      ckey_re = Regexp.new '^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$'
      user = create :user
      expect { user.refresh_auth }.to change { user.ckey }.to(ckey_re)
    end

    it 'should populate civ' do
      civ_re = Regexp.new '^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$'
      user = create :user
      expect { user.refresh_auth }.to change { user.civ }.to(civ_re)
    end

    it 'should populate auth_expires_at' do
      user = create :user
      Timecop.freeze
      auth_exipiration = User::AUTH_EXPIRATION_DURATION.from_now
      expect { user.refresh_auth }.to change { user.auth_expires_at }.to(auth_exipiration)
    end
  end
end
