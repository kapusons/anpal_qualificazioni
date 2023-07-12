class CreateCompetences < ActiveRecord::Migration[7.0]
  def change
    create_table :competences do |t|

      t.references :application
      t.string :atlante_competence
      t.string :atlante_code_competence
      t.string :competence

      t.timestamps
    end
  end
end
