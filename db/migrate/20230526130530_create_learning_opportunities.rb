class CreateLearningOpportunities < ActiveRecord::Migration[7.0]
  def change
    create_table :learning_opportunities do |t|

      t.references :application
      t.string :location
      t.string :duration
      t.string :manner
      t.string :institution
      t.timestamps
    end
  end
end
