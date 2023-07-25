# == Schema Information
#
# Table name: cities
#
#  id             :bigint           not null, primary key
#  province_id    :bigint
#  name           :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  code_catastale :string(255)
#  code_numerico  :string(255)
#
class City < ApplicationRecord

  belongs_to :province

  scope :ordered, -> { order(City.arel_table[:name])}
end
