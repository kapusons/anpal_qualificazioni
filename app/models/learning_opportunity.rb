# == Schema Information
#
# Table name: learning_opportunities
#
#  id             :bigint           not null, primary key
#  application_id :bigint
#  duration       :string(255)
#  manner         :string(255)
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


  validates :url, :start_at, :end_at, :institution, :manner, :duration, :region_id, :province_id, :city_id, presence: true
end
