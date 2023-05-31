namespace :anpal do

  desc "Create languages"
  task :languages => :environment do
    names = [
      { code: "it",	name: "italiano"},
      { code: "bg",	name: "bulgaro"},
      { code: "cs",	name: "ceco"},
      { code: "da",	name: "danese"},
      { code: "de",	name: "tedesco"},
      { code: "el",	name: "greco"},
      { code: "en",	name: "inglese"},
      { code: "es",	name: "spagnolo"},
      { code: "et",	name: "estone"},
      { code: "fi",	name: "finlandese"},
      { code: "fr",	name: "francese"},
      { code: "ga",	name: "irlandese"},
      { code: "hr",	name: "croato"},
      { code: "hu",	name: "ungherese"},
      { code: "lt",	name: "lituano"},
      { code: "lv",	name: "lettone"},
      { code: "mt",	name: "maltese"},
      { code: "nl",	name: "neerlandese"},
      { code: "pl",	name: "polacco"},
      { code: "pt",	name: "portoghese"},
      { code: "ro",	name: "rumeno"},
      { code: "sk",	name: "slovacco"},
      { code: "sl",	name: "sloveno"},
      { code: "sv",	name: "svedese"}
    ]
    names.each do |hash|
      Language.create(code: hash[:code], name: hash[:name].capitalize)
    end
  end

end