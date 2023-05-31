class CreateAtecos < ActiveRecord::Migration[7.0]
  def change
    create_table :atecos do |t|

      t.string :code
      t.string :description
      t.string :code_micro
      t.string :description_micro
      t.string :code_category
      t.text :description_category

      t.timestamps
    end

    create_table :application_atecos do |t|
      t.belongs_to :application
      t.belongs_to :ateco
      t.timestamps
    end

    Rake::Task['anpal:ateco'].invoke
  end
end
