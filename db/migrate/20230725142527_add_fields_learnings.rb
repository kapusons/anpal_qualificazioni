class AddFieldsLearnings < ActiveRecord::Migration[7.0]
  def change
    Rake::Task['anpal:remove_unless_certifying_agency'].invoke

    add_column :learning_opportunities, :start_at, :date
    add_column :learning_opportunities, :end_at, :date
    add_column :learning_opportunities, :url, :string
    add_column :learning_opportunities, :description, :text
  end
end
