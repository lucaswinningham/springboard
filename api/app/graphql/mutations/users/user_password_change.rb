module Mutations
  module Users
    class UserPasswordChange < BaseMutation
      argument :email, String, required: true
      argument :old_password, String, required: false
      argument :new_password, String, required: true

      type Types::Auth::UserJwtType

      attr_reader :email, :old_password, :new_password

      before_execute :validate_user!
      before_execute :validate_old_password!
      before_execute :validate_new_password!

      def execute
        if user.update password: new_password_validator.password
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
        errors.add 'User email not found.' unless user
      end

      def validate_old_password!
        return if user.password_digest.blank?

        errors.add 'Incorrect old_password.' unless old_password_validator.correct_password?
        errors.add 'Invalid old_password nonce.' unless old_password_validator.valid_nonce?
      end

      def validate_new_password!
        errors.add 'Invalid new_password nonce.' unless new_password_validator.valid_nonce?
      end

      def old_password_validator
        @old_password_validator ||= GraphMeta::Objects::Password::Validator.new(
          user: user, message: old_password
        )
      end

      def new_password_validator
        @new_password_validator ||= GraphMeta::Objects::Password::Validator.new(
          user: user, message: new_password
        )
      end
    end
  end
end
