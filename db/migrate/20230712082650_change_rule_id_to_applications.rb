class ChangeRuleIdToApplications < ActiveRecord::Migration[7.0]
  def up
    # rename_column :applications, :rule, :rule_id
    remove_reference :applications, :rule, foreign_key: true
    drop_table :rules
    add_column :applications, :rule, :string
  end

  def down
    remove_column :applications, :rule
    create_table :rules do |t|

      t.string :name
      t.timestamps
    end

    add_reference :applications, :rule, foreign_key: true
  end
end
