# == Schema Information
#
# Table name: nqf_levels
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class NqfLevel < ApplicationRecord
  validates :name, presence: true
end
