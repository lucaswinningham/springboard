RSpec.describe User, type: :model do
  describe '#create' do
    it 'should populate salt' do
      user = create :user, salt: nil
      valid_salt = BCrypt::Engine.valid_salt? user.salt
      expect(valid_salt).to be true
    end
  end

  describe '#save' do
    it 'should not change salt' do
      user = create :user
      expect { user.update salt: 'bogus' }.to_not change { user.reload.salt }.itself
    end
  end

  describe '#refresh_auth' do
    let(:user) { create :user, nonce: nil, ckey: nil, civ: nil, auth_expires_at: nil }

    it 'should populate nonce' do
      nonce_re = Regexp.new '^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$'
      expect { user.refresh_auth }.to change { user.nonce }.to(nonce_re)
    end

    it 'should populate ckey' do
      ckey = 'ckey'
      expect(AuthServices::CipherService).to receive(:random_key) { ckey }
      expect { user.refresh_auth }.to change { user.ckey }.to(ckey)
    end

    it 'should populate civ' do
      civ = 'civ'
      expect(AuthServices::CipherService).to receive(:random_iv) { civ }
      expect { user.refresh_auth }.to change { user.civ }.to(civ)
    end

    it 'should populate auth_expires_at' do
      Timecop.freeze do
        auth_exipiration = User::AUTH_EXPIRATION_DURATION.from_now
        expect { user.refresh_auth }.to change { user.auth_expires_at }.to(auth_exipiration)
      end
    end
  end
end
