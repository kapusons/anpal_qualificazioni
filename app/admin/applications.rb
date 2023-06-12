ActiveAdmin.register Application do

  # CUSTOM_ACTIONS = [ :page1, :page2, :save_page1, :save_page2]
  permit_params :id, :atlante, :atlante_title, :expiration_date, :region_id, :eqf_id, :certifying_agency_id, :guarantee_entity_id,
                :atlante_code, :atlante_region,
                :credit, :guarantee_process, :nqf_level_id, :nqf_level_in_id, :nqf_level_out_id, :language_id, :rule_id, :source_id,
                :admission_id, ateco_ids: [], cp_istat_ids: [], isced_ids: [], translations_attributes: [:id, :locale,
                                                                                                         :title, :description, :url], learning_opportunities_attributes: [:id, :_destroy, :application_id,
                                                                                                                                                                          :location, :duration, :manner, :institution]
  actions :all, except: [:create, :update]

  filter :translations_title_contains, label: I18n.t("active_admin.filters.application.translations_title_contains")
  filter :status_eq, as: :select, collection: Application.aasm.states.map(&:name).map { |a| [Application.human_enum_name(:status, a), a] }, label: I18n.t("active_admin.filters.application.status_eq")

  action_item :integration_request, only: [], if: proc { resource.completed? && (current_admin_user.super_admin? || current_admin_user.level_3?) } do
    link_to t('active_admin.applications.integration_request'), integration_request_admin_application_path(resource)
  end

  action_item :in_progress, only: [:show], if: proc { (resource.completed? && (current_admin_user.super_admin? || current_admin_user.level_3? || current_admin_user.level_2?)) || (resource.reviewed? && (current_admin_user.super_admin? || current_admin_user.level_3?)) } do
    link_to t('active_admin.applications.take'), in_progress_admin_application_path(resource)
  end

  member_action :in_progress, method: :get do
    @application = Application.find(params[:id])
    @application.in_progress_by = current_admin_user
    @application.in_progress!
    redirect_to admin_application_path(@application), notice: I18n.t('active_admin.applications.in_progress')
  end

  member_action :integration_request, method: :get do
    @application = Application.find(params[:id])
    @application.integrate!
    redirect_to admin_applications_path, notice: I18n.t('active_admin.applications.required_integration')
  end

  action_item :accept, only: [], if: proc { resource.completed? && (current_admin_user.super_admin? || current_admin_user.level_3?) } do
    link_to t('active_admin.applications.accept'), accept_admin_application_path(resource)
  end

  member_action :accept, method: :get do
    @application = Application.find(params[:id])
    @application.accept!
    redirect_to admin_applications_path, notice: I18n.t('active_admin.applications.accepted')
  end

  collection_action :atlante, method: :get do
    json = get_atlante_request("https://atlantetest.inapp.org/api/v2/adaCodice?codiceAda=#{params[:ada]}")
    response = json["code"] == 200 ? json["result"] : []
    render json: response
  end

  collection_action :create, method: :post do
    @application = build_resource
    @application.step = 1
    @application.skip_validation = params[:commit] == I18n.t("active_admin.actions.application.save_without_validation")
    if create_resource(@application)
      if @application.skip_validation
        render 'admin/page1', locals: { adas: adas, url: save_page1_admin_application_path(@application) }, layout: "active_admin"
      else
        render template: 'admin/page2', locals: { url: save_page2_admin_application_path(@application) }, layout: "active_admin"
      end
    else
      render template: 'admin/page1', locals: { adas: adas, url: admin_applications_path }, layout: "active_admin"
    end
  end

  member_action :page1, method: :get do
    @application = Application.find_or_initialize_by(id: params[:id])
    url = @application.persisted? ? save_page1_admin_application_path(@application) : admin_applications_path
    @application.step = 1
    render template: 'admin/page1', locals: { adas: adas, url: url }, layout: "active_admin"
  end

  member_action :save_page1, method: [:put, :patch] do
    @application = Application.find(params[:id])
    @application.assign_attributes(permitted_params.dig(:application) || {})
    @application.skip_validation = params[:commit] == I18n.t("active_admin.actions.application.save_without_validation")
    @application.step = 1
    if @application.save
      if @application.skip_validation
        render template: 'admin/page1', locals: { adas: adas, url: save_page1_admin_application_path(@application) }, layout: "active_admin"
      else
        render template: 'admin/page2', locals: { url: save_page2_admin_application_path(@application) }, layout: "active_admin"
      end
    else
      render template: 'admin/page1', locals: { adas: adas, url: save_page1_admin_application_path(@application) }, layout: "active_admin"
    end
  end

  member_action :page2, method: :get do
    @application = Application.find(params[:id])
    @application.step = 2
    render template: 'admin/page2', locals: { adas: adas, url: save_page2_admin_application_path(@application) }, layout: "active_admin"
  end

  member_action :save_page2, method: [:put, :patch] do
    @application = Application.find(params[:id])
    @application.step = 2
    @application.assign_attributes(permitted_params.dig(:application) || {})
    @application.skip_validation = params[:commit] == I18n.t("active_admin.actions.application.save_without_validation")
    if @application.save
      if @application.skip_validation
        render template: 'admin/page2', locals: { url: save_page2_admin_application_path(@application) }, layout: "active_admin"
      else
        @application.learning_opportunities.blank? ? @application.learning_opportunities.build : []
        render template: 'admin/page3', locals: { url: save_page3_admin_application_path(@application) }, layout: "active_admin"
      end

    else
      render template: 'admin/page2', locals: { url: save_page2_admin_application_path(@application) }, layout: "active_admin"
    end
  end

  member_action :page3, method: :get do
    @application = Application.find(params[:id])
    @application.learning_opportunities.blank? ? @application.learning_opportunities.build : []
    @application.step = 3
    render template: 'admin/page3', locals: { adas: adas, url: save_page3_admin_application_path(@application) }, layout: "active_admin"
  end

  member_action :save_page3, method: [:put, :patch] do
    @application = Application.find(params[:id])
    @application.step = 3
    @application.assign_attributes(permitted_params.dig(:application) || {})
    if @application.save
      @application.complete!
      redirect_to admin_applications_path, notice: I18n.t('active_admin.applications.sent_to_review')
    else
      @application.learning_opportunities.blank? ? @application.learning_opportunities.build : []
      render template: 'admin/page3', locals: { url: save_page3_admin_application_path(@application) }, layout: "active_admin"
    end
  end

  member_action :update1, method: [:put, :patch] do
    @application = Application.find(params[:id])
    @application.assign_attributes(permitted_params.dig(:application) || {})
    @application.skip_validation = params[:commit] == I18n.t("active_admin.actions.application.save_without_validation")
    @application.step = 1
    if @application.save
      render template: 'admin/page2', locals: { url: save_page2_admin_application_path(@application) }, layout: "active_admin"
    else
      render 'admin/page1', locals: { adas: adas, url: save_page1_admin_application_path(@application) }, layout: "active_admin"
    end
  end

  index download_links: false do
    selectable_column
    id_column
    column :title
    column :status do |a|
      user_type = current_admin_user.super_admin? || current_admin_user.level_2? || current_admin_user.level_3? ? "admin" : "user"
      status_tag Application.human_enum_name(:status, a.status), class: "#{a.status} #{user_type}"
    end
    column :created_by
    if current_admin_user.super_admin? || current_admin_user.level_2? || current_admin_user.level_3?
      column :in_progress_by
    end
    # column :status
    actions do |a|
      links = ""
      if a.completed? && (current_admin_user.super_admin? || current_admin_user.level_3? || current_admin_user.level_2?)
        links += link_to t('active_admin.applications.take'), in_progress_admin_application_path(a)
      end
      if a.reviewed? && (current_admin_user.super_admin? || current_admin_user.level_3?)
        links += link_to t('active_admin.applications.take'), in_progress_admin_application_path(a)
      end
      links.html_safe
    end
  end

  before_create do |application|
    application.created_by = current_admin_user
    application.updated_by = current_admin_user
  end

  before_update do |application|
    application.updated_by = current_admin_user
  end

  show do
    attributes_table do
      if current_admin_user.super_admin? || current_admin_user.level_3?
        row :atlante_code
        row :atlante_title
        row :atlante_region
      end
      row :status do |a|
        user_type = current_admin_user.super_admin? || current_admin_user.level_2? || current_admin_user.level_3? ? "admin" : "user"
        status_tag Application.human_enum_name(:status, a.status), class: "#{a.status} #{user_type}"
      end
      if current_admin_user.super_admin? || current_admin_user.level_2? || current_admin_user.level_3?
        row :in_progress_by
      end
      if application.accepted_with_advice?
        row :advice do
          application.comments.where(status: "accept").map(&:body).join("</br>").html_safe
        end
      end
      translate_attributes_table_with_label_for application do
        row :title
        row :url
        # row :description do |r|
        #   r.description
        # end
      end
      row :isceds
      row :region
      row :eqf
      row :certifying_agency
      row :isceds
      row :guarantee_entity
      row :credit
      row :nqf_level
      row :nqf_level_in
      row :nqf_level_out
      row :language
      row :rule
      row :source
      row :admission
      row :atecos
      row :cp_istats
      row :learning_opportunities do
        table_for application.learning_opportunities do
          column :location
          column :duration
          column :institution
          column :manner
        end
      end

      # row :expiration_date
      row :created_by
      row :created_at
      row :updated_at

    end

    active_admin_comments status: "integration_request"
    if ((resource.in_progress? && (resource.in_progress_by == current_admin_user || current_admin_user.super_admin?) ))
      div do
        button t('active_admin.applications.integration_request'), class: "button integration_request"
        button t('active_admin.applications.accept'), class: "button accept"
      end
    end

    active_admin_comments status: "integration_form", show_only_form: true
    active_admin_comments status: "accept_form", show_only_form: true

  end

  controller do

    def new
      @application = Application.new
      render template: 'admin/page1', locals: { adas: adas, url: admin_applications_path }, layout: "active_admin"
    end

    def edit
      @application = Application.find(permitted_params.dig(:id))
      render template: 'admin/page1', locals: { adas: adas, url: update1_admin_application_path(@application) }, layout: "active_admin"
    end

    # def determine_active_admin_layout
    #   CUSTOM_ACTIONS.include?(params[:action].to_sym) ? false : super
    # end
    def adas
      @adas ||= begin
                  json = get_atlante_request('https://atlantetest.inapp.org/api/v2/ada')
                  json["code"] == 200 ? json["result"].map { |a| [a["titolo"], a["codice"]] } : []
                end

    end

    def get_atlante_request(url)
      begin
      response = Faraday.get(url, {}, { 'Accept' => '*/*' })
      content = response.body.force_encoding("UTF-8")
      content.gsub!("\xEF\xBB\xBF".force_encoding("UTF-8"), '')
      JSON.parse(content)
      rescue
        {}
      end

    end

  end

end
