module Types
  module Auth
    class UserJwtType < BaseObject
      field :jwt, String, null: false
    end
  end
end
