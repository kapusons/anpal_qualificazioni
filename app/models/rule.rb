# == Schema Information
#
# Table name: rules
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Rule < ApplicationRecord
  validates :name, presence: true
end
