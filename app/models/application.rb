class Application < ApplicationRecord

  translates :title, :description

  accepts_nested_attributes_for :translations, allow_destroy: true, reject_if: proc { |att| att['description'].blank? && att['title'].blank? }

  class Translation
    has_rich_text :description
  end
end
