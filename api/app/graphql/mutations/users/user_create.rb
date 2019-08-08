module Mutations
  module Users
    class UserCreate < BaseMutation
      argument :name, String, required: true
      argument :email, String, required: true

      type Types::Auth::UserAuthType

      attr_reader :email, :name

      def mutate
        new_user = User.new name: name, email: email
        if new_user.save
          new_user.tap(&:trigger_confirmation).tap(&:refresh_auth)
        else
          errors.add_record new_user
        end
      end
    end
  end
end
