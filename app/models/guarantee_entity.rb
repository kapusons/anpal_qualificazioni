# == Schema Information
#
# Table name: guarantee_entities
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class GuaranteeEntity < ApplicationRecord
  validates :name, presence: true
end
