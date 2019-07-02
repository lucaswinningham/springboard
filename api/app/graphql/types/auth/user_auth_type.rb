module Types
  module Auth
    class UserAuthType < BaseObject
      field :salt, String, null: false
      field :nonce, String, null: false
      field :ckey, String, null: false
      field :civ, String, null: false
    end
  end
end
