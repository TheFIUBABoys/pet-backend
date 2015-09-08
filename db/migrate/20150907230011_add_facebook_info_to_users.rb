class AddFacebookInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_id, :string
    add_column :users, :facebook_token, :string
    add_column :users, :authentication_token, :string

    change_column :users, :email, :string, null: true
    change_column :users, :encrypted_password, :string, null: true
  end
end
