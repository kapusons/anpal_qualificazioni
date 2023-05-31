class CreateCpIstats < ActiveRecord::Migration[7.0]
  def change
    create_table :cp_istats do |t|

      t.string :code
      t.string :name
      t.text :description

      t.timestamps
    end

    create_table :application_cp_istats do |t|
      t.belongs_to :application
      t.belongs_to :cp_istat
      t.timestamps
    end

    Rake::Task['anpal:cp_istat'].invoke
  end
end
