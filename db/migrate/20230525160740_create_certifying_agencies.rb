class CreateCertifyingAgencies < ActiveRecord::Migration[7.0]
  def change
    create_table :certifying_agencies do |t|
      t.string :name
      t.timestamps
    end

    add_reference :applications, :certifying_agency, foreign_key: true
    Rake::Task['anpal:certifying_agencies'].invoke
  end
end
