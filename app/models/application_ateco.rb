# == Schema Information
#
# Table name: application_atecos
#
#  id             :bigint           not null, primary key
#  application_id :bigint
#  ateco_id       :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class ApplicationAteco < ApplicationRecord
  belongs_to :ateco
  belongs_to :application
end
