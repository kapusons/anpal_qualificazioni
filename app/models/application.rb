# == Schema Information
#
# Table name: applications
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  expiration_date :date
#  title           :string(255)
#  description     :text(65535)
#
class Application < ApplicationRecord

  attr_accessor :step

  translates :title, :description
  validates :title, :description, presence: true, if: -> { on_step(1) }
  validates :expiration_date, presence: true, if: -> { on_step(2) }

  accepts_nested_attributes_for :translations, allow_destroy: true, reject_if: proc { |att| att['description'].blank? && att['title'].blank? }

  class Translation
    has_rich_text :description
  end



  def on_step(step_number)
    step == step_number || step.nil?
  end

end
