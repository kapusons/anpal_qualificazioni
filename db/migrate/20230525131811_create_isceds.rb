class CreateIsceds < ActiveRecord::Migration[7.0]
  def change
    create_table :isceds do |t|

      t.string :name
      t.timestamps
    end

    create_table :application_isceds do |t|
      t.belongs_to :application
      t.belongs_to :isced
      t.timestamps
    end

    Rake::Task['anpal:isced'].invoke
  end
end
