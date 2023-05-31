class CreateNqfLevels < ActiveRecord::Migration[7.0]
  def change
    create_table :nqf_levels do |t|

      t.string :name
      t.timestamps
    end

    add_reference :applications, :nqf_level, foreign_key: true
    Rake::Task['anpal:nqf_levels'].invoke
  end
end
