namespace :anpal do

  desc "Create NQF Level"
  task :nqf_levels => :environment do
    names = [
      "IT 1.0",
      "IT 1.1",
      "IT 1.2",
      "IT.2.0",
      "IT 2.1",
      "IT 2.2",
      "IT 2.4",
      "IT.3.0",
      "IT 3.2",
      "IT 3.4",
      "IT.4.0",
      "IT 4.1",
      "IT 4.2",
      "IT 4.4",
      "IT.5.0",
      "IT 5.4",
      "IT.6.0",
      "IT 6.2",
      "IT 6.4",
      "IT.7.0",
      "IT 7.2",
      "IT 7.3",
      "IT 8.0",
      "IT 8.1",
      "IT 8.3"
    ]
    names.each do |name|
      NqfLevel.create(name: name)
    end
  end

  desc "Create NQF Level In"
  task :nqf_level_ins => :environment do
    names = [
      "IT 1.1",
      "IT 1.1 IDA",
      "IT 1.2",
      "IT 1.2 IDA",
      "IT 2.2 IeFP",
      "IT 2.2",
      "IT 2.2 IeFP",
      "IT 4.2",
      "IT 4.4 IeFP",
      "IT 4.1 IDA",
      "IT 4.2 IDA",
      "IT 3.4 IeFP",
      "IT 3.4 FP",
      "IT 2.2 IeFP",
      "IT 2.2 IDA",
      "IT 4.4 IeFP",
      "IT 4.1 IDA",
      "IT 4.2",
      "IT 4.2 IDA",
      "IT 4.4 IFTS",
      "IT 4.4 FP",
      "IT 6.2",
      "IT 6.4 FP",
      "IT 6.4 ITS Academy",
      "IT 7.2"
    ]
    names.each do |name|
      NqfLevelIn.create(name: name)
    end
  end

  desc "Create NQF Level Out"
  task :nqf_level_outs => :environment do
    names = [
      "IT.1.2",
      "IT 1.2 IDA",
      "IT 2.2",
      "IT 2.2 IeFP",
      "IT 2.4 FP",
      "IT 2.1 IDA",
      "IT 2.2 IDA",
      "IT 3.4",
      "IT 3.4 IeFP",
      "IT 3.4 FP",
      "IT 4.1 IDA",
      "IT 4.2",
      "IT 4.2 IDA",
      "IT 4.4 IeFP",
      "IT 4.4 FP",
      "IT 4.4 IFTS",
      "IT 5.4 FP",
      "IT 5.4 ITS Academy",
      "IT 6.2",
      "IT 6.4 ITS Academy",
      "IT 7.3 FP",
      "IT 7.2",
      "IT 7.3 MASTER",
      "IT 6.4 FP",
      "IT 8.1",
      "IT 8.3"
    ]
    names.each do |name|
      NqfLevelOut.create(name: name)
    end
  end

end