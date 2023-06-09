# == Schema Information
#
# Table name: active_admin_comments
#
#  id            :bigint           not null, primary key
#  namespace     :string(255)
#  body          :text(65535)
#  resource_type :string(255)
#  resource_id   :bigint
#  author_type   :string(255)
#  author_id     :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  status        :string(255)
#
require_dependency ActiveAdmin::Engine.root.join("lib", "active_admin", "orm", "active_record", "comments", "comment")

module ActiveAdmin
  class Comment < ActiveRecord::Base

    self.table_name = "#{table_name_prefix}active_admin_comments#{table_name_suffix}"

    belongs_to :resource, polymorphic: true, optional: true
    belongs_to :author, polymorphic: true

    validates_presence_of :body, :namespace, :resource

    before_create :set_resource_type

    # @return [String] The name of the record to use for the polymorphic relationship
    def self.resource_type(resource)
      ResourceController::Decorators.undecorate(resource).class.base_class.name.to_s
    end

    def self.find_for_resource_in_namespace(resource, namespace)
      where(
        resource_type: resource_type(resource),
        resource_id: resource.id,
        namespace: namespace.to_s
      ).order(ActiveAdmin.application.namespaces[namespace.to_sym].comments_order)
    end

    def set_resource_type
      self.resource_type = self.class.resource_type(resource)
    end

    scope :for_application_visible_by, -> (user) {
      filtered = self.joins("INNER JOIN applications on applications.id = resource_id AND resource_type = 'Application'")
      if user.super_admin?
        filtered = filtered.all
      elsif user.level_1?
        filtered = filtered.where(applications: { created_by_id: user.id })
      elsif user.level_2?
        filtered = filtered.where.not(applications: { status: 'draft' })
      elsif user.level_3?
        filtered = filtered.where.not(applications: { status: 'draft' })
      end
      filtered
    }

    scope :ordered, -> { order(created_at: :desc) }
  end
end
