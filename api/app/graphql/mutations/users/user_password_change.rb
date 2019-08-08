module Mutations
  module Users
    class UserPasswordChange < BaseMutation
      argument :email, String, required: true
      argument :old_password_message, String, required: true
      argument :new_password_message, String, required: true

      type Types::Auth::UserTokenType

      attr_reader :email, :old_password_message, :new_password_message

      before_mutation :validate_user!
      before_mutation :validate_old_password_message!
      before_mutation :validate_new_password_message!

      def mutate
        if user.update password: new_password
          user.tap(&:refresh_token)
        else
          errors.add_record user
        end
      end

      private

      def user
        @user ||= User.find_by email: email
      end

      def validate_user!
        add_error_message "User email #{email} not found." unless user
      end

      def validate_old_password_message!
        return if user.password_digest.blank?

        nonce, old_password = unpack_password_message old_password_message

        add_error_message "Invalid nonce: #{nonce}" unless valid_nonce? nonce
        add_error_message 'Wrong password.' unless user.password? old_password
      end

      def validate_new_password_message!
        nonce, _new_password = unpack_password_message new_password_message

        add_error_message "Invalid nonce: #{nonce}" unless valid_nonce? nonce
      end

      def valid_nonce?(nonce)
        !user.auth_expired? && user.nonce.present? && user.nonce == nonce
      end

      def new_password
        _nonce, password = unpack_password_message new_password_message
        password
      end

      def unpack_password_message(password_message)
        decrypted_message = AuthServices::CipherService.decrypt(
          message: password_message, key: user.ckey, iv: user.civ
        )
        nonce, password, _cnonce = decrypted_message.split('||')
        [nonce, password]
      end
    end
  end
end
