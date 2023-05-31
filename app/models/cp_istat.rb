# == Schema Information
#
# Table name: cp_istats
#
#  id          :bigint           not null, primary key
#  code        :string(255)
#  name        :string(255)
#  description :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class CpIstat < ApplicationRecord
end
