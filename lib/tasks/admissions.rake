namespace :anpal do

  desc "Create admission"
  task :admissions => :environment do
    names = [0,1,2,3,4,5,6,7]
    names.each do |name|
      Admission.create(name: name)
    end
  end

end