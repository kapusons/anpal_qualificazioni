class CreateNqfLevelIns < ActiveRecord::Migration[7.0]
  def change
    create_table :nqf_level_ins do |t|

      t.string :name
      t.timestamps
    end

    add_reference :applications, :nqf_level_in, foreign_key: true
    Rake::Task['anpal:nqf_level_ins'].invoke
  end
end
