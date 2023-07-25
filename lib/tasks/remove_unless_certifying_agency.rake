
namespace :anpal do
  desc "Remove certifying agency"
  task :remove_unless_certifying_agency => :environment do
    CertifyingAgency.find_by(name: "Regioni e P.A. Trento e Bolzano (dobbiamo inserire per esteso l'elenco delle Regioni)").try(:destroy)
  end

end