# == Schema Information
#
# Table name: eqfs
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Eqf < ApplicationRecord
  validates :name, presence: true

end
