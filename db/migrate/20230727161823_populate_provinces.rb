class PopulateProvinces < ActiveRecord::Migration[7.0]
  def change
    Rake::Task['anpal:provinces'].invoke
  end
end
