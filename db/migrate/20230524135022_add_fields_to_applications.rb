class AddFieldsToApplications < ActiveRecord::Migration[7.0]
  def change
    add_column :applications, :atlante_code, :string
    add_column :applications, :atlante_title, :string
  end
end
