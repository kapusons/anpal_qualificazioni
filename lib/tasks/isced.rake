namespace :anpal do

  desc "Create ISCED"
  task :isced => :environment do
    names = [
      "0O Generic programmes and qualifications",
      "01 Education",
      "O2 Arts and humanities",
      "03 Social sciences, journalism and information",
      "04 Business, administration and law",
      "05 Natural sciences, mathematics and statistics",
      "06 Information and communication Technologies (ICTs)",
      "07 Engineering, manufacturing and construction",
      "08 Agriculture, forestry, fisheries and veterinary",
      "09 Health and welfare",
      "10 Services"
    ]
    names.each do |name|
      Isced.create(name: name)
    end
  end

end