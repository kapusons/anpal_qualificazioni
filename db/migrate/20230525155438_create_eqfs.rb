class CreateEqfs < ActiveRecord::Migration[7.0]
  def change
    create_table :eqfs do |t|
      t.string :name
      t.timestamps
    end

    add_reference :applications, :eqf, foreign_key: true
    Rake::Task['anpal:eqf'].invoke
  end
end
