class AddCreatorToApplications < ActiveRecord::Migration[7.0]
  def change
    add_reference :applications, :created_by
    add_reference :applications, :updated_by
  end
end
