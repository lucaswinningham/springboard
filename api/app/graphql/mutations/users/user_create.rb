module Mutations
  module Users
    class UserCreate < BaseMutation
      argument :name, String, required: true
      argument :email, String, required: true

      type Types::Auth::UserAuthType

      attr_reader :email, :name

      after_execute :trigger_confirmation

      def execute
        if new_user.save
          new_user.tap(&:refresh_auth)
        else
          errors.add_record new_user
        end
      end

      private

      def new_user
        @new_user ||= User.new name: name, email: email
      end

      def trigger_confirmation
        new_user.trigger_confirmation
      end
    end
  end
end
