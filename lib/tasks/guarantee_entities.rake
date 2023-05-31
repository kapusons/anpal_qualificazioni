namespace :anpal do

  desc "Create guarantee entity"
  task :guarantee_entities => :environment do
    names = [
      "INVALSI", "ANVUR", "INDIRE", "CIMEA", "CRRS&S", "EQAVET"
    ]
    names.each do |name|
      GuaranteeEntity.create(name: name)
    end
  end

end