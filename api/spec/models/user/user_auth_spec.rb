RSpec.describe User, type: :model do
  describe 'salt' do
    context 'on create' do
      it 'should populate salt' do
        user = create :user, salt: nil
        valid_salt = BCrypt::Engine.valid_salt? user.salt
        expect(valid_salt).to be true
      end
    end

    context 'when updating' do
      it 'should not change salt' do
        user = create :user
        expect { user.update salt: 'bogus' }.to_not change { user.reload.salt }.itself
      end
    end
  end

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
      expect { user.refresh_auth }.to change { user.nonce }.to(be_truthy)
    end

    it 'should populate ckey' do
      expect { user.refresh_auth }.to change { user.ckey }.to(be_truthy)
    end

    it 'should populate civ' do
      expect { user.refresh_auth }.to change { user.civ }.to(be_truthy)
    end

    it 'should populate auth_expires_at' do
      Timecop.freeze do
        auth_exipiration = User::AUTH_EXPIRATION_DURATION.from_now
        expect { user.refresh_auth }.to change { user.auth_expires_at }.to(auth_exipiration)
      end
    end
  end
end
