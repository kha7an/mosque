class RenameEmailAddressToLoginOnUsers < ActiveRecord::Migration[8.0]
  def change
    rename_column :users, :email_address, :login
  end
end