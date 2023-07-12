# == Schema Information
#
# Table name: knowledges
#
#  id                     :bigint           not null, primary key
#  competence_id          :bigint
#  knowledge              :string(255)
#  atlante_knowledge      :string(255)
#  atlante_code_knowledge :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class Knowledge < ApplicationRecord

  belongs_to :competence
end
