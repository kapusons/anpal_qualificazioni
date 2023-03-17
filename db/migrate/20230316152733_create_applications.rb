class CreateApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :applications do |t|

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        Application.create_translation_table! title: :string, description: :text
      end

      dir.down do
        Application.drop_translation_table!
      end
    end
  end
end
