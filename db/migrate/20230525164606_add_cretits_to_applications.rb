class AddCretitsToApplications < ActiveRecord::Migration[7.0]
  def change
    add_column :applications, :credit, :string
    add_column :applications, :guarantee_process, :string

    reversible do |dir|
      dir.up do
        Application.add_translation_fields! url: :string
      end

      dir.down do
        remove_column :application_translations, :url
      end
    end

  end
end
