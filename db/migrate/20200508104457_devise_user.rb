class DeviseUser < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :password_digest, :string
    remove_column :users, :remember_digest, :string
    add_column :users, :encrypted_password, :string, null: false, default: ''
    add_column :users, :remember_created_at, :datetime
  end
end
