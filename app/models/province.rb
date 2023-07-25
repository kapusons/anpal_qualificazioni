# == Schema Information
#
# Table name: provinces
#
#  id         :bigint           not null, primary key
#  region_id  :bigint
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  code       :string(255)
#
class Province < ApplicationRecord

  belongs_to :region
  has_many :cities

  scope :ordered, -> { order(Province.arel_table[:name])}
end
