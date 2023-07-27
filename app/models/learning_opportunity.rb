# == Schema Information
#
# Table name: learning_opportunities
#
#  id             :bigint           not null, primary key
#  application_id :bigint
#  duration       :string(255)
#  institution    :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  region_id      :bigint
#  province_id    :bigint
#  city_id        :bigint
#  start_at       :date
#  end_at         :date
#  url            :string(255)
#  description    :text(65535)
#
class LearningOpportunity < ApplicationRecord
  belongs_to :region
  belongs_to :province
  belongs_to :city

  has_many :learning_opportunity_manners
  has_many :manners, through: :learning_opportunity_manners

  validates :manner_ids, :url, :start_at, :end_at, :institution, :duration, :region_id, :province_id, :city_id, presence: true
end
