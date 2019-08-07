module ClientMocks
  class UserPasswordMock
    def self.hash_password(user:, password:)
      BCrypt::Engine.hash_secret password, user.salt
    end

    def self.pack_password_message(user:, password:)
      hashed_password = hash_password user: user, password: password
      message = "#{user.nonce}||#{hashed_password}"
      AuthServices::CipherService.encrypt message: message, key: user.ckey, iv: user.civ
    end
  end
end
