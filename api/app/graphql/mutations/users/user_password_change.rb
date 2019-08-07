module Mutations
  module Users
    class UserPasswordChange < BaseMutation
      argument :email, String, required: true
      argument :old_password_message, String, required: true
      argument :new_password_message, String, required: true

      type Types::Auth::UserTokenType

      attr_reader :email, :old_password_message, :new_password_message

      def resolve(email: nil, old_password_message: nil, new_password_message: nil)
        @email = email
        return not_found_error unless user

        if user.password_digest
          @old_password_message = old_password_message
          nonce, old_password = unpack_password_message old_password_message
          return invalid_nonce_error unless valid_nonce? nonce
          return invalid_old_password_error unless user.password? old_password
        end

        @new_password_message = new_password_message
        nonce, new_password = unpack_password_message new_password_message
        return invalid_nonce_error unless valid_nonce? nonce

        if user.update password: new_password
          user.tap(&:refresh_token)
        else
          validation_error user
        end
      end

      private

      def unpack_password_message(password_message)
        decrypted_message = AuthServices::CipherService.decrypt(
          message: password_message, key: user.ckey, iv: user.civ
        )
        nonce, password, _cnonce = decrypted_message.split('||')
        [nonce, password]
      end

      def user
        @user ||= User.find_by email: email
      end

      def valid_nonce?(nonce)
        !user.auth_expired? && user.nonce && user.nonce == nonce
      end

      def not_found_error
        GraphQL::ExecutionError.new "User email #{email} not found."
      end

      def invalid_nonce_error
        GraphQL::ExecutionError.new 'Invalid nonce.'
      end
    end
  end
end
