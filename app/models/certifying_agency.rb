# == Schema Information
#
# Table name: certifying_agencies
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class CertifyingAgency < ApplicationRecord

  validates :name, presence: true
end
