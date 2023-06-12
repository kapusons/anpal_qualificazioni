class CreateSources < ActiveRecord::Migration[7.0]
  def change
    create_table :sources do |t|

      t.string :name
      t.timestamps
    end

    add_reference :applications, :source, foreign_key: true
    Rake::Task['anpal:sources'].invoke
  end
end
