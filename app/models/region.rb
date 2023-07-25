# == Schema Information
#
# Table name: regions
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Region < ApplicationRecord
  validates :name, presence: true

  has_many :provinces

  scope :ordered, -> { order(Arel::Nodes::Case.new.when(Region.arel_table[:name].eq('Italia')).then(1).else(2), Region.arel_table[:name])}
  scope :without_italy, -> { where.not(Region.arel_table[:name].eq('Italia')) }
  default_scope { ordered }
end
