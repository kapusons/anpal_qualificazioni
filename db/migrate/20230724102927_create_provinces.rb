class CreateProvinces < ActiveRecord::Migration[7.0]
  def change
    create_table :provinces do |t|

      t.references :region
      t.string :name
      t.timestamps
    end
  end
end
