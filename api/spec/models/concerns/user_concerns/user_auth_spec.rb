RSpec.describe User, type: :model do
  describe 'nonce' do
    it 'should allow correct values' do
      valid_values = 3.times.map { SecureRandom.base64 }
      should allow_values(*valid_values).for(:nonce)
    end

    it 'should now allow incorrect values' do
      should_not allow_values('bogus').for(:nonce)
    end
  end

  describe 'ckey' do
    it 'should allow correct values' do
      valid_values = 3.times.map { AuthServices::CipherService.random_key }
      should allow_values(*valid_values).for(:ckey)
    end

    it 'should now allow incorrect values' do
      should_not allow_values('bogus').for(:ckey)
    end
  end

  describe 'civ' do
    it 'should allow correct values' do
      valid_values = 3.times.map { AuthServices::CipherService.random_iv }
      should allow_values(*valid_values).for(:civ)
    end

    it 'should now allow incorrect values' do
      should_not allow_values('bogus').for(:civ)
    end
  end

  describe 'jwt_key' do
    let(:user) { create :user, jwt_key: nil }

    context 'on create' do
      it 'should populate jwt_key' do
        valid_jwt_key = user.jwt_key =~ Regexp.new('\A(?:[a-z0-9+/]{2})*\z')
        expect(valid_jwt_key).to be_truthy
      end
    end

    context 'on save' do
      it 'should not change jwt_key' do
        expect { user.update jwt_key: 'bogus' }.to_not change { user.reload.jwt_key }.itself
      end

      it 'should add jwt_key error to user' do
        user.update jwt_key: 'bogus'
        jwt_key_error = user.errors.key? :jwt_key
        expect(jwt_key_error).to be true
      end
    end
  end

  describe '#refresh_auth' do
    let(:user) { create :user, nonce: nil, ckey: nil, civ: nil, auth_expires_at: nil }

    it 'should populate nonce' do
      new_nonce = SecureRandom.base64

      expect(SecureRandom).to receive(:base64) { new_nonce }
      expect { user.refresh_auth }.to change { user.nonce }.to new_nonce
    end

    it 'should populate ckey' do
      new_ckey = AuthServices::CipherService.random_key

      expect(AuthServices::CipherService).to receive(:random_key) { new_ckey }
      expect { user.refresh_auth }.to change { user.ckey }.to new_ckey
    end

    it 'should populate civ' do
      new_iv = AuthServices::CipherService.random_iv

      expect(AuthServices::CipherService).to receive(:random_iv) { new_iv }
      expect { user.refresh_auth }.to change { user.civ }.to new_iv
    end

    it 'should populate auth_expires_at' do
      Timecop.freeze do
        auth_exipiration = User::AUTH_EXPIRATION_DURATION.from_now.utc

        expect { user.refresh_auth }.to change { user.auth_expires_at }.to auth_exipiration
      end
    end
  end

  describe '#auth_expired?' do
    let!(:user) { create(:user).tap(&:refresh_auth) }

    context 'when auth is not expired' do
      it 'should return false' do
        Timecop.freeze do
          expect(user.auth_expired?).to be false
        end
      end
    end

    context 'when auth is expired' do
      it 'should return true' do
        Timecop.travel User::AUTH_EXPIRATION_DURATION.from_now.utc do
          expect(user.auth_expired?).to be true
        end
      end
    end
  end

  describe '#refresh_jwt' do
    let(:user) { create :user }

    it 'should use service to issue new jwt' do
      jwt = 'jwt'
      expect(AuthServices::JwtService).to receive(:encode) { jwt }
      expect(user.refresh_jwt).to be jwt
    end

    it 'should set #jwt to new jwt' do
      jwt = user.refresh_jwt
      expect(jwt).to eq user.jwt
    end
  end
end
