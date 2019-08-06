module Types
  module Auth
    class UserTokenType < BaseObject
      field :token, String, null: false
    end
  end
end
