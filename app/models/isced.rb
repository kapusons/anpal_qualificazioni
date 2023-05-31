# == Schema Information
#
# Table name: isceds
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Isced < ApplicationRecord
  validates :name, presence: true
end
