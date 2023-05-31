# == Schema Information
#
# Table name: application_cp_istats
#
#  id             :bigint           not null, primary key
#  application_id :bigint
#  cp_istat_id    :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class ApplicationCpIstat < ApplicationRecord
  belongs_to :cp_istat
  belongs_to :application
end
