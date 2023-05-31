class CreateLanguages < ActiveRecord::Migration[7.0]
  def change
    create_table :languages do |t|

      t.string :code
      t.string :name
      t.timestamps
    end

    add_reference :applications, :language, foreign_key: true
    Rake::Task['anpal:languages'].invoke
  end
end
