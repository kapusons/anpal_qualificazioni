namespace :anpal do

  desc "Create regions (Abruzzo, ..)"
  task :regions => :environment do
    names = [
      "Abruzzo", "Basilicata", "Calabria", "Campania", "Emilia-Romagna", "Friuli-Venezia Giulia", "Lazio",
      "Liguria", "Lombardia", "Molise", "Piemonte", "Provincia autonoma di Trento ", "Provincia autonoma di Bolzano", "Puglia", "Sardegna", "Sicilia", "Toscana", "Umbria",
      "Valle d'Aosta/Vallée d'Aoste", "Veneto"
    ]
    names.each do |name|
      Region.create(name: name)
    end
  end

end