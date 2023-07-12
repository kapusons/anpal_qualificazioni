# == Schema Information
#
# Table name: competences
#
#  id                      :bigint           not null, primary key
#  application_id          :bigint
#  atlante_competence      :string(255)
#  atlante_code_competence :string(255)
#  competence              :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
class Competence < ApplicationRecord
  has_many :responsibilities, dependent: :destroy
  has_many :abilities, dependent: :destroy
  has_many :knowledges, dependent: :destroy

  accepts_nested_attributes_for :responsibilities, allow_destroy: true, reject_if: proc { |att| att['responsibility'].blank? }
  accepts_nested_attributes_for :abilities, allow_destroy: true, reject_if: proc { |att| att['ability'].blank? }
  accepts_nested_attributes_for :knowledges, allow_destroy: true, reject_if: proc { |att| att['knowledge'].blank? }


  def to_json
    super
  end
end
