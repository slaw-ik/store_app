class AddFieldCurrentSignInTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :current_sign_in_token, :string
  end
end
