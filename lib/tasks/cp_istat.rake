require 'roo'

namespace :anpal do

  desc "Create CP2021"
  task :cp_istat => :environment do

    workbook = Roo::Spreadsheet.open './lib/imports/CP2021.xlsx'
    worksheets = workbook.sheets
    puts "Found #{worksheets.count} worksheets"

    worksheet = "quinto_digit"
    puts "Reading: #{worksheet}"
    num_rows = 0
    workbook.sheet(worksheet).each(headers: true) do |row|
      num_rows += 1
      next if num_rows == 1

      CpIstat.create(code: row["cod_5"],
                     name: row["nome_5"],
                   description: row["descr_5"])

    end
    puts "Read #{num_rows} rows"
  end

end