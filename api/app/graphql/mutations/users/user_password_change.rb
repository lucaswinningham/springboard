module Mutations
  module Users
    class UserPasswordChange < BaseMutation
      argument :email, String, required: true
      argument :prev_password, String, required: false
      argument :next_password, String, required: true

      type Types::Auth::UserJwtType

      attr_reader :email, :prev_password, :next_password

      before_execute :validate_user!
      before_execute :validate_prev_password!
      before_execute :validate_next_password!

      def execute
        if user.update password: new_password
          user.tap(&:refresh_jwt)
        else
          errors.add_record user
        end
      end

      private

      def user
        @user ||= User.find_by email: email
      end

      def validate_user!
        errors.add "User email #{email} not found." unless user
      end

      def validate_prev_password!
        return if user.password_digest.blank?

        nonce, old_password = unpack_password_message prev_password

        errors.add "Invalid prev_password nonce: '#{nonce}'" unless valid_nonce? nonce
        errors.add 'Incorrect prev_password.' unless user.password? old_password
      end

      def validate_next_password!
        nonce, _new_password = unpack_password_message next_password

        errors.add "Invalid next_password nonce: '#{nonce}'" unless valid_nonce? nonce
      end

      def valid_nonce?(nonce)
        !user.auth_expired? && user.nonce.present? && user.nonce == nonce
      end

      def new_password
        _nonce, password = unpack_password_message next_password
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
