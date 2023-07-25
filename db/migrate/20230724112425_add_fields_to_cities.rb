class AddFieldsToCities < ActiveRecord::Migration[7.0]
  def change
    add_column :cities, :code_catastale, :string
    add_column :cities, :code_numerico, :string
    add_column :provinces, :code, :string
  end
end
