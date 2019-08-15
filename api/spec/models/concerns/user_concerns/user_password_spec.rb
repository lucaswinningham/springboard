require 'support/client_mocks/user_password_mock'

RSpec.describe User, type: :model do
  let(:user) { create :user, salt: nil, password_digest: nil, password: nil }

  describe 'salt' do
    context 'on create' do
      it 'should populate salt' do
        valid_salt = BCrypt::Engine.valid_salt? user.salt
        expect(valid_salt).to be true
      end
    end

    context 'on save' do
      it 'should not change salt' do
        expect { user.update salt: 'bogus' }.to_not change { user.reload.salt }.itself
      end

      it 'should add salt error to user' do
        user.update salt: 'bogus'
        salt_error = user.errors.key? :salt
        expect(salt_error).to be true
      end
    end
  end

  describe 'password_digest' do
    context 'on save' do
      it 'should not change password_digest' do
        expect { user.update password_digest: 'bogus' }.to_not(
          change { user.reload.password_digest }
        )
      end

      it 'should add password_digest error to user' do
        user.update password_digest: 'bogus'
        password_digest_error = user.errors.key? :password_digest
        expect(password_digest_error).to be true
      end
    end
  end

  describe '#password' do # these pass password_digest validations and i don't think they should
    context 'with valid password argument' do
      let(:password) { 'plain_password' }
      let(:hashed) do
        Support::ClientMocks::UserPasswordMock.hash_password user: user, password: password
      end

      it 'should populate password_digest' do
        expect { user.update password: hashed }.to change { user.password_digest }.to be_truthy
      end

      it 'should populate password_digest with hash of password argument' do
        user.update password: hashed

        digest_password = BCrypt::Password.new(user.password_digest)
        is_password = digest_password.is_password? hashed
        expect(is_password).to be true
      end
    end

    context 'with invalid password argument' do
      it 'should not populate password_digest' do
        expect { user.update password: 'bogus' }.to_not change { user.password_digest }.itself
      end

      it 'should add password error to user' do
        user.update password: 'bogus'
        password_error = user.errors.key? :password
        expect(password_error).to be true
      end
    end
  end

  describe '#password?' do
    let(:password) { 'plain_password' }
    let(:hashed) do
      Support::ClientMocks::UserPasswordMock.hash_password user: user, password: password
    end

    before { user.update password: hashed }

    context 'with correct password' do
      it 'should return true' do
        correct_password = user.password? hashed
        expect(correct_password).to be true
      end
    end

    context 'with incorrect password' do
      it 'should return false' do
        correct_password = user.password? password
        expect(correct_password).to be false
      end
    end
  end
end
