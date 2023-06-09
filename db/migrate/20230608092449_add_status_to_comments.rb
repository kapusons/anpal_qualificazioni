class AddStatusToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :active_admin_comments, :status, :string
  end
end
