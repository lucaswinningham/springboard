module Mutations
  module Users
    class UserPasswordChange < BaseMutation
      argument :email, String, required: true
      argument :old_password, String, required: true
      argument :new_password, String, required: true

      type Types::Auth::UserTokenType

      def resolve(name: nil, old_password: nil, new_password: nil)
        # new_user = User.new name: name, email: email
        # if new_user.save
        #   new_user.tap(&:trigger_confirmation).tap(&:refresh_auth)
        # else
        #   validation_error new_user
        # end
      end
    end
  end
end
