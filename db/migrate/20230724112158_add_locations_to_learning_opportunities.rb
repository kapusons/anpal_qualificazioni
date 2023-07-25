class AddLocationsToLearningOpportunities < ActiveRecord::Migration[7.0]
  def change
    remove_column :learning_opportunities, :location, :string
    add_reference :learning_opportunities, :region
    add_reference :learning_opportunities, :province
    add_reference :learning_opportunities, :city
  end
end
