namespace :anpal do

  desc "Create source"
  task :sources => :environment do
    names = [
      "Ordinamenti del Ministero dell'Istruzione per l’istruzione secondaria superiore (licei e istituti tecnici e professionali) e per l’istruzione degli adulti",
      "Repertori regionali della formazione professionale adottati dalle Regioni con propri atti",
      "Repertori di figure di riferimento nazionale della IeFP ",
      "Istruzione e Formazione Professionale",
    ]
    names.each do |name|
      Source.create(name: name)
    end
    Application.destroy_all
    Rule.destroy_all
  end

end