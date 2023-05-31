# == Schema Information
#
# Table name: learning_opportunities
#
#  id             :bigint           not null, primary key
#  application_id :bigint
#  location       :string(255)
#  duration       :string(255)
#  manner         :string(255)
#  institution    :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class LearningOpportunity < ApplicationRecord
end
