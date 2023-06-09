ActiveAdmin.after_load do |app|
  app.namespaces.each do |namespace|
    namespace.register ActiveAdmin::Comment, as: namespace.comments_registration_name do

      actions :index, :create, :destroy

      # OLD
      #menu namespace.comments ? namespace.comments_menu : false
      # NEW
      menu parent: I18n.t("active_admin.menu.parents.administration"), if: proc {
        current_admin_user.super_admin? || current_admin_user.level_3?
      }

      config.comments = false # Don't allow comments on comments
      # OLD
      # config.batch_actions = false # The default destroy batch action isn't showing up anyway...
      # NEW
      config.batch_actions = true # The default destroy batch action isn't showing up anyway...

      # OLD
      # scope :all, show_count: false
      # app.namespaces.map(&:name).each do |name|
      #   scope name, default: namespace.name == name do |scope|
      #     scope.where namespace: name.to_s
      #   end
      # end

      # Store the author and namespace
      before_save do |comment|
        comment.namespace = active_admin_config.namespace.name
        comment.author = current_active_admin_user
      end

      controller do
        # Prevent N+1 queries
        def scoped_collection
          super.includes(:author, :resource)
        end

        # Redirect to the resource show page after comment creation
        def create
          if params[:commit] == I18n.t("active_admin.comments.send_acceptance_request")
            flash[:notice] = I18n.t("active_admin.comments.sent_acceptance_request")
            Application.find_by(id: params.dig(:active_admin_comment, :resource_id)).accept!
            redirect_back(fallback_location: active_admin_root) && return
          end

          if params[:commit] == I18n.t("active_admin.comments.send_acceptance_review")
            flash[:notice] =  I18n.t("active_admin.comments.sent_acceptance_review")
            Application.find_by(id: params.dig(:active_admin_comment, :resource_id)).review!
            redirect_back(fallback_location: active_admin_root) && return
          end
          create! do |success, failure|
            success.html do
              if current_admin_user.level_3?
                if params[:commit] == I18n.t("active_admin.comments.send_integration_request")
                  flash[:notice] = I18n.t("active_admin.comments.sent_integration_request")
                  resource.resource.integrate!
                elsif params[:commit] == I18n.t("active_admin.comments.send_acceptance_request_with_advice")
                  flash[:notice] = I18n.t("active_admin.comments.sent_acceptance_request_with_advice")
                  resource.resource.accept_with_advice!
                elsif params[:commit] == I18n.t("active_admin.comments.send_acceptance_request")
                  # teoricamente qui non entra mai
                  flash[:notice] = I18n.t("active_admin.comments.sent_acceptance_request")
                  resource.resource.accept!
                end
              elsif current_admin_user.level_2?
                if params[:commit] == I18n.t("active_admin.comments.send_integration_request")
                  flash[:notice] = I18n.t("active_admin.comments.sent_integration_request")
                  resource.resource.integrate!
                elsif params[:commit] == I18n.t("active_admin.comments.send_integration_request")
                  # teoricamente qui non entra mai
                  flash[:notice] =  I18n.t("active_admin.comments.sent_integration_request")
                  resource.resource.review!
                end
              end
              redirect_back fallback_location: active_admin_root
            end
            failure.html do
              flash[:error] = I18n.t "active_admin.comments.errors.empty_text"
              redirect_back fallback_location: active_admin_root
            end
          end

          def destroy
            destroy! do |success, failure|
              success.html do
                redirect_back fallback_location: active_admin_root
              end
              failure.html do
                redirect_back fallback_location: active_admin_root
              end
            end
          end
        end
      end

      permit_params :body, :namespace, :resource_id, :resource_type, :status

      filter :body
      # Non va bene perchè un livello 1 vede un altro livello 1
      # filter :author_of_AdminUser_type_id_eq, as: :select, collection: -> { AdminUser.all.map { |a| [a.name, a.id] } }, label: I18n.t("active_admin.filters.location.author_of_AdminUser_type_id_eq")

      # OLD
      # index do
      #   column I18n.t("active_admin.comments.resource_type"), :resource_type
      #   column I18n.t("active_admin.comments.author_type"), :author_type
      #   column I18n.t("active_admin.comments.resource"), :resource
      #   column I18n.t("active_admin.comments.author"), :author
      #   column I18n.t("active_admin.comments.body"), :body
      #   column I18n.t("active_admin.comments.created_at"), :created_at
      #   actions
      # end

      # NEW
      index download_links: false do
        selectable_column
        id_column
        column :body
        column I18n.t("active_admin.comments.author"), :author
        column I18n.t("active_admin.comments.resource"), :resource
        column I18n.t("active_admin.comments.created_at"), :created_at
        actions do |comment|
          if authorized?(ActiveAdmin::Auth::READ, comment.resource)
            localizer = ActiveAdmin::Localizers.resource(active_admin_config)
            item localizer.t(:view), admin_application_path(comment.resource).concat("/#active_admin_comment_#{comment.id}"), class: "view_link member_link", title: localizer.t(:view)
          end
        end
      end

    end
  end
end