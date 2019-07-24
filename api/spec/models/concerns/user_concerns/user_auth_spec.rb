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

  describe '#refresh_auth' do
    let(:user) { create :user, nonce: nil, ckey: nil, civ: nil, auth_expires_at: nil }

    it 'should populate nonce' do
      new_nonce = SecureRandom.base64
      expect(SecureRandom).to receive(:base64) { new_nonce }
      expect { user.refresh_auth }.to change { user.reload.nonce }.to new_nonce
    end

    it 'should populate ckey' do
      new_ckey = AuthServices::CipherService.random_key
      expect(AuthServices::CipherService).to receive(:random_key) { new_ckey }
      expect { user.refresh_auth }.to change { user.reload.ckey }.to new_ckey
    end

    it 'should populate civ' do
      new_iv = AuthServices::CipherService.random_iv
      expect(AuthServices::CipherService).to receive(:random_iv) { new_iv }
      expect { user.refresh_auth }.to change { user.reload.civ }.to new_iv
    end

    it 'should populate auth_expires_at' do
      Timecop.freeze do
        auth_exipiration = User::AUTH_EXPIRATION_DURATION.from_now
        expect { user.refresh_auth }.to change { user.reload.auth_expires_at }.to auth_exipiration
      end
    end
  end
end
