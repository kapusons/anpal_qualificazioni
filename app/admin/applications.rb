ActiveAdmin.register Application do

  CUSTOM_ACTIONS = [ :page1, :page2, :save_page1, :save_page2]
  permit_params :id, :expiration_date, translations_attributes: [ :id, :locale, :title, :description ]
  actions :all, except: [:new, :create, :update] # New e Create personalizzate

  filter :translations_title_contains, label: I18n.t("active_admin.filters.application.translations_title_contains")
  filter :translations_rich_text_description_body_contains, label: I18n.t("active_admin.filters.application.translations_description_contains")


  # Add button NEW
  action_item :page1, only: [:index, :show] do
    link_to t('active_admin.applications.new_application'), page1_admin_applications_path
  end

  # define routes & controller method
  collection_action :page1, method: :get do
    @application = Application.new
    render template: 'admin/page1', locals: {url: save_page1_admin_applications_path},  layout: "active_admin"
  end

  collection_action :save_page1, method: :post do
    @application = build_resource
    @application.step = 1
    if create_resource(@application)
      render template: 'admin/page2', locals: { url: save_page2_admin_application_path(@application)},  layout: "active_admin"
    else
      render template: 'admin/page1', locals: { url: save_page1_admin_applications_path},  layout: "active_admin"
    end
  end

  member_action :save_page2, method: [:put, :patch] do
    @application = Application.find(params[:id])
    @application.step = 2
    @application.assign_attributes(permitted_params.dig(:application))
    if @application.save
      redirect_to admin_applications_path, notice:  I18n.t('active_admin.applications.created_successfully')
    else
      render template: 'admin/page2', locals: { url: save_page2_admin_application_path(@application)},  layout: "active_admin"
    end
  end

  member_action :update1, method: [:put, :patch] do
    @application = Application.find(params[:id])
    @application.assign_attributes(permitted_params.dig(:application))
    @application.step = 1
    if @application.save
      render template: 'admin/page2', locals: { url: save_page2_admin_application_path(@application)},  layout: "active_admin"
    else
      render 'admin/page1', layout: "active_admin"
    end
  end


  index do
    selectable_column
    id_column
    column :title
    column :description
    column :expiration_date
    actions
  end

  show do
    attributes_table do
      translate_attributes_table_for application do
        row :title
        row :description do |r|
          r.description
        end
      end
      row :expiration_date
      row :created_at
      row :updated_at
    end
  end

  controller do

    def edit
      @application = Application.find(permitted_params.dig(:id))
      render template: 'admin/page1', locals: { url: update1_admin_application_path(@application)},  layout: "active_admin"
    end

    # def determine_active_admin_layout
    #   CUSTOM_ACTIONS.include?(params[:action].to_sym) ? false : super
    # end

  end
  
end
