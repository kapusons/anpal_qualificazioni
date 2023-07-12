# == Schema Information
#
# Table name: abilities
#
#  id                   :bigint           not null, primary key
#  competence_id        :bigint
#  ability              :string(255)
#  atlante_ability      :string(255)
#  atlante_code_ability :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Ability < ApplicationRecord

  belongs_to :competence
end
