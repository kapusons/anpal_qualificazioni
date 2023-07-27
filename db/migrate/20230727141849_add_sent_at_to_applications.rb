class AddSentAtToApplications < ActiveRecord::Migration[7.0]
  def change
    add_column :applications, :sent_at, :date
  end
end
