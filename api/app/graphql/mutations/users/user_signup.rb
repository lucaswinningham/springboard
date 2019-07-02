module Mutations
  module Users
    class UserSignup < BaseMutation
      argument :name, String, required: true
      argument :email, String, required: true

      type Types::Auth::UserAuthType

      def resolve(email: nil, name: nil)
        new_user = User.new name: name, email: email
        if new_user.save
          new_user.tap(&:refresh_auth)
        else
          validation_error new_user
        end
      end
    end
  end
end
