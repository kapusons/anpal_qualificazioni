class AddNameToAdminUser < ActiveRecord::Migration[7.0]
  def up
    add_column :admin_users, :name, :string
  end

  def down
    remove_column :admin_users, :name, :string
  end
end
