module AuthServices
  class CipherService
    def self.encrypt(message:, key:, iv:) # rubocop:disable Naming/UncommunicativeMethodParamName
      cipher = new_cipher.tap(&:encrypt)
      key = Base64.decode64 key
      iv = Base64.decode64 iv
      cipher.key = Base64.decode64 key
      cipher.iv = Base64.decode64 iv
      encrypted = cipher.update(message) + cipher.final
      encrypted_and_encoded = Base64.encode64 encrypted
      encrypted_and_encoded
    end

    def self.decrypt(message:, key:, iv:) # rubocop:disable Naming/UncommunicativeMethodParamName
      decoded = Base64.decode64 message
      cipher = new_cipher.tap(&:decrypt)
      cipher.key = Base64.decode64 key
      cipher.iv = Base64.decode64 iv
      decoded_and_decrypted = cipher.update(decoded) + cipher.final
      decoded_and_decrypted
    end

    def self.random_key
      Base64.encode64 new_cipher.tap(&:encrypt).random_key
    end

    def self.random_iv
      Base64.encode64 new_cipher.tap(&:encrypt).random_iv
    end

    def self.new_cipher
      OpenSSL::Cipher::AES128.new(:CBC)
    end
  end
end
