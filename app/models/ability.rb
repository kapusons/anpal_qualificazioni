class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= AdminUser.new

    alias_action :create, :read, :update, to: :not_delete
    alias_action :read, :close, to: :close_actions

    can [:update], AdminUser, AdminUser.where(id: user) do |admin_user|
      admin_user.id == user.id
    end

    if user.level_1?
      can [:create, :update], Application, Application.created_from(user) do |application|
        application.created_by == user && (application.draft? || application.integration_required? )
      end
      can :read, Application, Application.created_from(user) do |application|
        application.created_by == user
      end
      can :not_delete, ActiveAdmin::Comment, ActiveAdmin::Comment.joins("INNER JOIN applications as a on a.id = resource_id AND resource_type = 'Application'") do |comment|
        # application.created_by == user
      end
      can :create, ActiveAdmin::Comment, ActiveAdmin::Comment.joins("INNER JOIN applications as a on a.id = resource_id AND resource_type = 'Application'") do |comment|
        comment.resource.created_by == user# && comment.resource.completed?
      end
      cannot :read, Rule
    elsif user.level_2?
      can [:read], Application, Application.not_in_draft do |aa|
        Application.completed
      end
      can :not_delete, ActiveAdmin::Comment
    elsif user.level_3?
      can :read, AdminUser
      can [:read], Application, Application.not_in_draft do |aa|
        Application.completed
      end
      can :not_delete, ActiveAdmin::Comment
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
