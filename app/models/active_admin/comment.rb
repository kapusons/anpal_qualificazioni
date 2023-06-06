require_dependency ActiveAdmin::Engine.root.join("lib", "active_admin", "orm", "active_record", "comments", "comment")

class ActiveAdmin::Comment

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
