# == Schema Information
#
# Table name: responsibilities
#
#  id                          :bigint           not null, primary key
#  competence_id               :bigint
#  responsibility              :string(255)
#  atlante_responsibility      :string(255)
#  atlante_code_responsibility :string(255)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
class Responsibility < ApplicationRecord

  belongs_to :competence
end
