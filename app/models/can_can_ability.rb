class CanCanAbility
  include CanCan::Ability

  def initialize(user)
    user ||= AdminUser.new

    alias_action :create, :read, :update, to: :not_delete
    alias_action :read, :close, to: :close_actions

    can [:update], AdminUser, AdminUser.where(id: user) do |admin_user|
      admin_user.id == user.id
    end

    if user.level_1?
      can :read, Region
      can :read, Province
      can :read, City
      can [:create, :update], Application, Application.created_from(user) do |application|
        application.created_by == user && (application.draft? || application.integration_required? )
      end
      can [:learning_opportunity], Application, Application.created_from(user) do |application|
        application.created_by == user && (application.accepted_with_advice? || application.accepted? )
      end
      can :read, Application, Application.created_from(user) do |application|
        application.created_by == user
      end
      can :read, ActiveAdmin::Comment, ActiveAdmin::Comment.for_application_visible_by(user) do |comment|
        comment.resource.created_by == user && comment.resource.integration_request?
      end
      # can :not_delete, ActiveAdmin::Comment, ActiveAdmin::Comment.for_application_visible_by(user) do |comment|
      #   comment.resource.created_by == user
      # end
      can :download, ActiveAdmin::Comment, ActiveAdmin::Comment.for_application_visible_by(user) do |comment|
        comment.status == "integration_request" && comment.resource.created_by == user
      end
      cannot :review, Application
      cannot :read, Rule
    elsif user.level_2?
      can [:read], Application, Application.inapp do |aa|
        aa.inapp?
      end
      can :not_delete, ActiveAdmin::Comment, ActiveAdmin::Comment.for_application_visible_by(user) do |comment|
        user.super_admin? || user.level_3? || user.level_2? || comment.resource.created_by == user
      end
      can :download, ActiveAdmin::Comment, ActiveAdmin::Comment.for_application_visible_by(user) do |comment|
        comment.status == "integration_request" || (comment.status == "inapp" && comment.resource.inapp?)
      end
      cannot :review, Application
      # non funziona
      # cannot :create, ActiveAdmin::Comment, ActiveAdmin::Comment.for_application_visible_by(user) do |comment|
      #   comment.resource.in_progress?
      # end
    elsif user.level_3?
      can :read, Region
      can :read, Province
      can :read, City
      can :read, AdminUser
      can [:read], Application, Application.not_in_draft do |aa|
        Application.not_in_draft
      end
      # can :not_delete, ActiveAdmin::Comment, ActiveAdmin::Comment.for_application_visible_by(user) do |comment|
      #   user.super_admin? || user.level_3? || user.level_2? || comment.resource.created_by == user# && comment.resource.completed?
      # end
      # cannot :create, ActiveAdmin::Comment, ActiveAdmin::Comment.for_application_visible_by(user) do |comment|
      #   comment.resource.integration_required?
      # end
      can :not_delete, ActiveAdmin::Comment, ActiveAdmin::Comment.for_application_visible_by(user) do |comment|
        user.super_admin? || user.level_3? || user.level_2? || comment.resource.created_by == user
      end
      # non funziona
      # cannot :create, ActiveAdmin::Comment, ActiveAdmin::Comment.for_application_visible_by(user) do |comment|
      #   comment.resource.in_progress?
      # end
      can :versions, Application, Application.not_in_draft do |aa|
        Application.not_in_draft
      end
      can :review, Application, Application.not_in_draft do |aa|
        aa.in_progress_by == user && aa.in_progress?
      end
      can :download, ActiveAdmin::Comment, ActiveAdmin::Comment.for_application_visible_by(user) do |comment|
        comment.status == "integration_request" || comment.status == "inapp"
      end
      can :read, :all
    else
      can :manage, Application
    end

    if user.super_admin?
      can :manage, :all
    end

    # can :access, :ckeditor
    # can :manage, Ckeditor::Picture
    # can :manage, Ckeditor::AttachmentFile
    # can :manage, Ckeditor::Asset
    # NOTE: Everyone can read the page of Permission Deny
    can :read, ActiveAdmin::Page, name: "Dashboard"
  end
end
