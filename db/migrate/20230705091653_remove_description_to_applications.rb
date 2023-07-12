class RemoveDescriptionToApplications < ActiveRecord::Migration[7.0]
  def change
    remove_column :application_translations, :description, :text
  end
end
