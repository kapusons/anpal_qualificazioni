# == Schema Information
#
# Table name: nqf_level_outs
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class NqfLevelOut < ApplicationRecord
  validates :name, presence: true
end
