# == Schema Information
#
# Table name: application_isceds
#
#  id             :bigint           not null, primary key
#  application_id :bigint
#  isced_id       :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class ApplicationIsced < ApplicationRecord
  belongs_to :isced
  belongs_to :application
end
