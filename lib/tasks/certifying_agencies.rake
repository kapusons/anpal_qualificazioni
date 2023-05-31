namespace :anpal do

  desc "Create certifying agency"
  task :certifying_agencies => :environment do
    names = [
      "Ministero Istruzione e Merito", "Ministero Università e Ricerca",
      "Ministero del Lavoro e delle Politiche Sociali",
      "Regioni e P.A. Trento e Bolzano (dobbiamo inserire per esteso l'elenco delle Regioni)",
      "Abruzzo", "Basilicata", "Calabria", "Campania", "Emilia-Romagna", "Friuli-Venezia Giulia", "Lazio",
      "Liguria", "Lombardia", "Molise", "Piemonte", "Provincia autonoma di Trento ", "Provincia autonoma di Bolzano", "Puglia", "Sardegna", "Sicilia", "Toscana", "Umbria",
      "Valle d'Aosta/Vallée d'Aoste", "Veneto"
    ]
    names.each do |name|
      CertifyingAgency.create(name: name)
    end
  end

end