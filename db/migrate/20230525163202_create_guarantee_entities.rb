class CreateGuaranteeEntities < ActiveRecord::Migration[7.0]
  def change
    create_table :guarantee_entities do |t|

      t.string :name
      t.timestamps
    end

    add_reference :applications, :guarantee_entity, foreign_key: true
    Rake::Task['anpal:guarantee_entities'].invoke
  end
end
