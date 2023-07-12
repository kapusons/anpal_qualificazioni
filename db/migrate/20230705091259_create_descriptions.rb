class CreateDescriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :knowledges do |t|

      t.references :competence
      t.string :knowledge
      t.string :atlante_knowledge
      t.string :atlante_code_knowledge

      t.timestamps
    end


    create_table :abilities do |t|

      t.references :competence
      t.string :ability
      t.string :atlante_ability
      t.string :atlante_code_ability

      t.timestamps
    end

    create_table :responsibilities do |t|

      t.references :competence
      t.string :responsibility
      t.string :atlante_responsibility
      t.string :atlante_code_responsibility

      t.timestamps
    end
  end
end
