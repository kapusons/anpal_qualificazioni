# == Schema Information
#
# Table name: languages
#
#  id         :bigint           not null, primary key
#  code       :string(255)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Language < ApplicationRecord
  validates :name, :code, presence: true
end
