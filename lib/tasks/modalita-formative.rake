namespace :anpal do

  desc "Create manners"
  task :manners => :environment do

    dir = "#{Rails.root}/lib"
    csv = CSV.read("#{dir}/ElencoModalitaFormative.csv", headers: true, row_sep: "\r\n", col_sep: ";", quote_char: "\"")


    csv.each do |r|
      Manner.create(name: r['Descrizione'], siu_id: r["﻿Id SIU formazione"].to_i, parent_siu_id: r['ParentIdSIU'])
    end

  end

end