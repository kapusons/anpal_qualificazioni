class AddManners < ActiveRecord::Migration[7.0]
  def up
    remove_column :learning_opportunities, :manner

    create_table :manners do |t|

      t.integer :siu_id
      t.references :parent_siu
      t.string :name
      t.timestamps
    end

    create_table :learning_opportunity_manners do |t|
      t.belongs_to :learning_opportunity
      t.belongs_to :manner
      t.timestamps
    end

    Rake::Task['anpal:manners'].invoke
  end

  def down
    drop_table :learning_opportunity_manners
    drop_table :manners
    add_column :learning_opportunities, :manner, :string
  end
end
