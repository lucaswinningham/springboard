module AuthServices
  class CipherService
    VALID_CIPHER_REGEXP = Regexp.new(
      # '\A(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==\n|[A-Za-z0-9+/]{3}=)?\z'
      '\A(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==\n)?\z'
    ).freeze
    VALID_KEY_REGEXP = VALID_CIPHER_REGEXP
    VALID_IV_REGEXP = VALID_CIPHER_REGEXP

    def self.encrypt(message:, key:, iv:) # rubocop:disable Naming/UncommunicativeMethodParamName
      cipher = new_cipher.tap(&:encrypt)
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

    class << self
      private

      def new_cipher
        OpenSSL::Cipher::AES128.new(:CBC)
      end
    end
  end
end
