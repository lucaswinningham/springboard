class AddAuthToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :nonce, :string
    add_column :users, :civ, :string
    add_column :users, :ckey, :string
    add_column :users, :auth_expires_at, :datetime
    add_column :users, :jwt_key, :string
  end
end
