class CreateAdmissions < ActiveRecord::Migration[7.0]
  def change
    create_table :admissions do |t|

      t.string :name
      t.timestamps
    end

    add_reference :applications, :admission, foreign_key: true
    Rake::Task['anpal:admissions'].invoke
  end
end
