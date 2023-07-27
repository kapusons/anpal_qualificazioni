class AddAtlanteRegionToApplications < ActiveRecord::Migration[7.0]
  def change
    add_column :applications, :atlante_region, :string
  end
end
