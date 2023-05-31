class CreateRules < ActiveRecord::Migration[7.0]
  def change
    create_table :rules do |t|

      t.string :name
      t.timestamps
    end

    add_reference :applications, :rule, foreign_key: true
    Rake::Task['anpal:rules'].invoke
  end
end
