namespace :anpal do

  desc "Create rule"
  task :rules => :environment do
    names = [
      "Ordinamenti del Ministero dell'Istruzione per l’istruzione secondaria superiore (licei e istituti tecnici e professionali) e per l’istruzione degli adulti",
      "Repertori regionali della formazione professionale adottati dalle Regioni con propri atti",
      "Repertori di figure di riferimento nazionale della IeFP ",
      "Istruzione e Formazione Professional",
    ]
    names.each do |name|
      Rule.create(name: name)
    end
  end

end