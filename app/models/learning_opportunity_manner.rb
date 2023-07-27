# == Schema Information
#
# Table name: learning_opportunity_manners
#
#  id                      :bigint           not null, primary key
#  learning_opportunity_id :bigint
#  manner_id               :bigint
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
class LearningOpportunityManner < ApplicationRecord
  belongs_to :manner
  belongs_to :learning_opportunity
end
