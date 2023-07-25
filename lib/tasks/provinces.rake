namespace :anpal do

  desc "Create provinces & municipalities"
  task :provinces => :environment do

    # Mancavano le Marche
    e = Region.find_or_initialize_by(name: "Marche")
    e.save


    regions = {}
    Region.all.each { |r| regions.merge!(r.name => r.name) }
    region_names = { "Valle d'Aosta" => "Valle d'Aosta/Vallée d'Aoste", "Trentino Alto Adige" => "Trentino-Alto Adige/Südtirol", "Emilia Romagna" => "Emilia-Romagna", "Friuli Venezia Giulia" => "Friuli-Venezia Giulia" }
    regions.merge!(region_names)
    dir = "#{Rails.root}/lib"
    csv = CSV.read("#{dir}/Elenco-comuni-italiani.csv", headers: true, row_sep: "\r\n", col_sep: ";", quote_char: "\"")

    csv.each do |r|
      nome_comune_csv = r["Denominazione in italiano"]
      targa = r["Sigla automobilistica"]
      nome_regione_csv = r['Denominazione Regione']
      nome_provincia_csv = r["Denominazione dell'Unità territoriale sovracomunale \n(valida a fini statistici)"]

      current_region_name = regions.key(nome_regione_csv)
      region = Region.find_by(name: current_region_name)
      if region.nil?
        if current_region_name == "Trentino Alto Adige"
          if nome_provincia_csv == "Trento"
            region = Region.find_by(name: "Provincia autonoma di Trento ")
          elsif nome_provincia_csv == "Bolzano/Bozen"
            region = Region.find_by(name: "Provincia autonoma di Bolzano")
          else
            puts "ERRORE: provincia trentino non trovata"
          end
        end
      end
      puts "Regione non trovata errore" if region.nil?

      province = Province.find_or_initialize_by(code: targa) do |a|
        a.region = region
        a.name = nome_provincia_csv
      end
      province.save!


      City.create(name: nome_comune_csv, province: province, code_catastale: r['Codice Catastale del comune'], code_numerico: r['Codice Comune formato numerico'])

    end

  end

end