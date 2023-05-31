# == Schema Information
#
# Table name: admissions
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Admission < ApplicationRecord
  validates :name, presence: true
end
