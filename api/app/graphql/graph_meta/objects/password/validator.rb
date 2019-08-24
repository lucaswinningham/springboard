module GraphMeta
  module Objects
    module Password
      class Validator
        attr_reader :user, :message
        attr_reader :nonce, :password, :cnonce

        def initialize(user:, message:)
          @user = user
          @message = message
          unpack_message
        end

        def valid_nonce?
          @valid_nonce ||= !user.auth_expired? && user.nonce.present? && user.nonce == nonce
        end

        def correct_password?
          @correct_password ||= user.password? password
        end

        private

        def unpack_message
          decrypted_message = AuthServices::CipherService.decrypt(
            message: message, key: user.ckey, iv: user.civ
          )

          @nonce, @password, @cnonce = decrypted_message.split('||')
        end
      end
    end
  end
end
