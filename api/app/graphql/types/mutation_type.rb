module Types
  class MutationType < Types::BaseObject
    field :user_create, mutation: Mutations::Users::UserCreate
    field :user_password_change, mutation: Mutations::Users::UserPasswordChange
  end
end
