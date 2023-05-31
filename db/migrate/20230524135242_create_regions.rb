class CreateRegions < ActiveRecord::Migration[7.0]
  def change
    create_table :regions do |t|

      t.string :name
      t.timestamps
    end

    add_reference :applications, :region, foreign_key: true
  end
end
