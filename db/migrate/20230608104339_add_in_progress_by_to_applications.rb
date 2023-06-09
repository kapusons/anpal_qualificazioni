class AddInProgressByToApplications < ActiveRecord::Migration[7.0]
  def change
    add_reference :applications, :in_progress_by
  end
end
