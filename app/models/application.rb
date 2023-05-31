# == Schema Information
#
# Table name: applications
#
#  id                   :bigint           not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  expiration_date      :date
#  atlante_code         :string(255)
#  atlante_title        :string(255)
#  region_id            :bigint
#  eqf_id               :bigint
#  certifying_agency_id :bigint
#  guarantee_entity_id  :bigint
#  credit               :string(255)
#  guarantee_process    :string(255)
#  nqf_level_id         :bigint
#  nqf_level_in_id      :bigint
#  nqf_level_out_id     :bigint
#  language_id          :bigint
#  rule_id              :bigint
#  admission_id         :bigint
#  created_by_id        :bigint
#  updated_by_id        :bigint
#  status               :string(255)
#  title                :string(255)
#  description          :text(65535)
#  url                  :string(255)
#
class Application < ApplicationRecord
  include AASM

  aasm column: 'status' do
    state :draft, initial: true
    state :completed
    state :integration_required
    state :reviewed
    state :accepted
    event :complete do
      transitions from: [:draft, :integration_required], to: :completed
    end
    event :integrate do
      transitions from: :completed, to: :integration_required
    end
    event :review do
      transitions from: :completed, to: :reviewed
    end
    event :accept do
      transitions from: :completed, to: :accepted
    end
  end

  attr_accessor :step, :atlante, :skip_validation
  translates :title, :description, :url, fallbacks_for_empty_translations: false

  belongs_to :region, optional: true
  belongs_to :eqf, optional: true
  belongs_to :certifying_agency, optional: true
  belongs_to :guarantee_entity, optional: true
  belongs_to :nqf_level, optional: true
  belongs_to :nqf_level_in, optional: true
  belongs_to :nqf_level_out, optional: true
  belongs_to :language, optional: true
  belongs_to :rule, optional: true
  belongs_to :admission, optional: true
  has_many :application_atecos
  has_many :atecos, through: :application_atecos
  has_many :application_cp_istats
  has_many :cp_istats, through: :application_cp_istats
  has_many :application_isceds
  has_many :isceds, through: :application_isceds
  has_many :learning_opportunities
  belongs_to :created_by, class_name: "AdminUser"
  belongs_to :updated_by, class_name: "AdminUser"
  has_many :comments, class_name: "ActiveAdmin::Comment", as: :resource

  scope :created_from, -> (current_user) { where(created_by: current_user) }
  scope :not_in_draft, -> { where.not(status: 'draft') }


  STEP_1_FIELD_TO_VALIDATE = [:title, :url, :region, :nqf_level, :nqf_level_in, :nqf_level_out, :isced_ids, :credit]
  validates :title, presence: true, if: :need_validate_1?
  validates :url, presence: true, if: :need_validate_1?
  validates :region, presence: true, if: :need_validate_1?
  validates :nqf_level, presence: true, if: :need_validate_1?
  validates :nqf_level_in, presence: true, if: :need_validate_1?
  validates :nqf_level_out, presence: true, if: :need_validate_1?
  validates :isced_ids, presence: true, if: :need_validate_1?
  validates :credit, numericality: { only_integer: true, allow_blank: true}, if: :need_validate_1?


  STEP_2_FIELD_TO_VALIDATE = [:language, :rule, :admission, :certifying_agency, :eqf]
  # validates :expiration_date, presence: true, if: -> { on_step(2) }
  validates :language, presence: true, if: :need_validate_2?
  validates :rule, presence: true, if: :need_validate_2?
  validates :admission, presence: true, if: :need_validate_2?
  validates :certifying_agency, presence: true, if: :need_validate_2?
  validates :eqf, presence: true, if: :need_validate_2?

  #todo: verificare presenza di errori nello step3
  STEP_3_FIELD_TO_VALIDATE = []

  def need_validate_1?
    (!skip_validation && on_step(1)) || on_step(3)
  end

  def need_validate_2?
    (!skip_validation && on_step(2)) || on_step(3)
  end

  accepts_nested_attributes_for :translations, allow_destroy: true, reject_if: proc { |att| att['description'].blank? && att['title'].blank? }
  accepts_nested_attributes_for :learning_opportunities, allow_destroy: true, reject_if: :all_blank

  class Translation
    has_rich_text :description
  end

  def on_step(step_number)
    step == step_number || step.nil?
  end

  def errors_present?(current_step)
    ("#{self.class}::STEP_#{current_step}_FIELD_TO_VALIDATE".constantize & errors.map(&:attribute)).any?
  end

  def self.human_enum_name(enum_name, enum_value)
    I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{enum_name.to_s.pluralize}.#{enum_value}")
  end

end
