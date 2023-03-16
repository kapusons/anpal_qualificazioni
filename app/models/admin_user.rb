class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :trackable, :async

  enum role: [ :super_admin, :level_1, :level_2, :level_3, :level_4, :level_5, :level_6 ]

end
