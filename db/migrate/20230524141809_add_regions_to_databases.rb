class AddRegionsToDatabases < ActiveRecord::Migration[7.0]
  def change
    Rake::Task['anpal:regions'].invoke
  end

end
