ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do

    div class: "blank_slate_container", id: "dashboard_default_message" do
      span class: "blank_slate" do
        span I18n.t('active_admin.dashboards.welcome').concat(current_admin_user.level_1? ? "<br/><br/>" : "").concat(current_admin_user.level_1? ? (link_to I18n.t('active_admin.dashboards.create'),  new_admin_application_path, class: 'button primary') : "").html_safe
      end
    end

    columns class: 'dashboard-columns' do
      column do
        panel (I18n.t('active_admin.dashboards.last_applications')).concat(link_to I18n.t('active_admin.dashboards.see_all'),  admin_applications_path, style: "float: right;").html_safe do
          @applications = Application.distinct.dashboard_for(current_admin_user).ordered_by_comment_or_status_for(current_admin_user).limit(10)

          if @applications.present?
            table_for @applications do
              column :title
              column :status do |a|
                user_type = current_admin_user.super_admin? || current_admin_user.level_2? || current_admin_user.level_3? ? "admin" : "user"
                status_tag Application.human_enum_name(:status, a.status), class: "#{a.status} #{user_type}"
              end
              column :comments do |a|
                link_to a.comments.where(status: "integration_request").count, admin_application_path(a).concat("#active_admin_comments_for_application_#{a.id}")
              end
              column("") { |a| link_to(I18n.t('active_admin.dashboards.detail'), admin_application_path(a)) }
            end
          else
            h4 I18n.t('active_admin.dashboards.nothing')
          end
        end
      end

      column do
        #.concat(link_to I18n.t('active_admin.dashboards.see_all'),  admin_comments_path, style: "float: right;")
        panel (I18n.t('active_admin.dashboards.last_comments')).html_safe do
          @comments = ActiveAdmin::Comment.where(status: "integration_request").for_application_visible_by(current_admin_user).ordered.limit(10)

          if @comments.present?
            table_for @comments do
              column :body
              column :resource
              column :author
              column("") { |a| link_to(I18n.t('active_admin.dashboards.detail'), admin_application_path(a.resource_id).concat("/#active_admin_comments_for_application_#{a.resource_id}")) }
            end
          else
            h4 I18n.t('active_admin.dashboards.nothing')
          end
        end
      end


    end

  end
end
