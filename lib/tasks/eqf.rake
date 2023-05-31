namespace :anpal do

  desc "Create EQF"
  task :eqf => :environment do
    names = [1,2,3,4,5,6,7,8]
    names.each do |name|
      Eqf.create(name: name)
    end
  end

end