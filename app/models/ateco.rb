# == Schema Information
#
# Table name: atecos
#
#  id                   :bigint           not null, primary key
#  code                 :string(255)
#  description          :string(255)
#  code_micro           :string(255)
#  description_micro    :string(255)
#  code_category        :string(255)
#  description_category :text(65535)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Ateco < ApplicationRecord
  validates :code, :description, :code_micro, :description_micro, :code_category, :description_category, presence: true

  def display_name
    "#{self.code_category} - #{self.description_category}"
  end
end
