module Types
  class MutationType < Types::BaseObject
    field :user_signup, mutation: Mutations::Users::UserSignup
  end
end
