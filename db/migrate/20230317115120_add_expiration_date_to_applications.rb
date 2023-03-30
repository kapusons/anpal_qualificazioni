class AddExpirationDateToApplications < ActiveRecord::Migration[7.0]
  def change
    add_column :applications, :expiration_date, :date
  end
end
