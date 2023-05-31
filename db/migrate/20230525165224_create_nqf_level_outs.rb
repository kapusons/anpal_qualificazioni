class CreateNqfLevelOuts < ActiveRecord::Migration[7.0]
  def change
    create_table :nqf_level_outs do |t|

      t.string :name
      t.timestamps
    end

    add_reference :applications, :nqf_level_out, foreign_key: true
    Rake::Task['anpal:nqf_level_outs'].invoke
  end
end
