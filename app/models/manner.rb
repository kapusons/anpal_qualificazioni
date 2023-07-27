# == Schema Information
#
# Table name: manners
#
#  id            :bigint           not null, primary key
#  siu_id        :integer
#  parent_siu_id :bigint
#  name          :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Manner < ApplicationRecord
  validates :name, presence: true

  belongs_to :parent, class_name: 'Manner', optional: true, foreign_key: :parent_siu_id, primary_key: :siu_id
  has_many :child, class_name: 'Manner', foreign_key: :parent_siu_id, primary_key: :siu_id

  def self.grouped_options
    where(parent_siu_id: nil).map do |p|
      [[p.name, p.id], p.child.map{ |a| [a.name, a.id] }]
    end
  end
end
