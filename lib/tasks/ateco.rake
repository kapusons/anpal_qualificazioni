require 'roo'

namespace :anpal do

  desc "Create ateco"
  task :ateco => :environment do

    workbook = Roo::Spreadsheet.open './lib/imports/Ateco.xlsx'
    worksheets = workbook.sheets
    puts "Found #{worksheets.count} worksheets"

    worksheets.each do |worksheet|
      puts "Reading: #{worksheet}"
      num_rows = 0
      workbook.sheet(worksheet).each(headers: true) do |row|
        num_rows += 1
        next if num_rows == 1

        Ateco.create(code: row["Codice ANPAL"],
                     description: row["Descrizione"],
                     code_micro: row["codMicroSezioneAteco"],
                     description_micro: row["desMicroSezioneAteco"],
                     code_category: row["codCategoriaAteco"],
                     description_category: row["desCategoriaAteco"])

      end
      puts "Read #{num_rows} rows"
    end
  end

end