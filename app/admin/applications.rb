ActiveAdmin.register Application do

  # CUSTOM_ACTIONS = [ :page1, :page2, :save_page1, :save_page2]
  permit_params :id, :atlante, :atlante_title, :expiration_date, :region_id, :eqf_id, :certifying_agency_id, :guarantee_entity_id,
                :atlante_code, :atlante_region,
                :credit, :guarantee_process, :nqf_level_id, :nqf_level_in_id, :nqf_level_out_id, :language_id, :rule, :source_id,
                :admission_id, ateco_ids: [], cp_istat_ids: [], isced_ids: [], competences_attributes: [:id, :_destroy, :competence, :atlante_competence, :atlante_code_competence,
                                                                                                        knowledges_attributes: [:id, :_destroy, :knowledge, :atlante_knowledge, :atlante_code_knowledge],
                                                                                                        abilities_attributes: [:id, :_destroy, :ability, :atlante_ability, :atlante_code_ability],
                                                                                                        responsibilities_attributes: [:id, :_destroy, :responsibility, :atlante_responsibility, :atlante_code_responsibility],],
                translations_attributes: [:id, :locale, :title, :url], learning_opportunities_attributes: [:id, :_destroy, :application_id, :region_id, :province_id, :city_id, :duration, :institution, :start_at, :end_at, :description, :url, manner_ids: []]
  actions :all, except: [:create, :update]

  filter :translations_title_contains, label: I18n.t("active_admin.filters.application.translations_title_contains")
  filter :status_eq, as: :select, collection: Application.aasm.states.map(&:name).map { |a| [Application.human_enum_name(:status, a), a] }, label: I18n.t("active_admin.filters.application.status_eq")
  filter :sent_at_eq, as: :select, collection: ["Tutti", "Urgenti"], label: I18n.t("active_admin.filters.application.expired"), if: proc { current_admin_user.super_admin? || current_admin_user.level_2? || current_admin_user.level_3? }

  action_item :integration_request, only: [], if: proc { resource.completed? && (current_admin_user.super_admin? || current_admin_user.level_3?) } do
    link_to t('active_admin.applications.integration_request'), integration_request_admin_application_path(resource)
  end

  action_item :in_progress, only: [:show], if: proc { (resource.completed? && (current_admin_user.super_admin? || current_admin_user.level_3?)) } do
    link_to t('active_admin.applications.take'), in_progress_admin_application_path(resource)
  end

  action_item :review, only: [:show], if: proc { authorized?(:review, resource) } do
    link_to t('active_admin.applications.review'), review_admin_application_path(resource)
  end

  action_item :page3, only: [:show], if: proc { (resource.accepted? || resource.accepted_with_advice?) && (current_admin_user.super_admin? || current_admin_user.level_1?) } do
    link_to t('active_admin.applications.add_learning_opportunities'), page3_admin_application_path(resource)
  end

  member_action :review, method: :get do
    @application = Application.find(params[:id])
    if authorized?(:review, @application)
      @application.send_to_inapp!
      redirect_to admin_application_path(@application), notice: I18n.t('active_admin.applications.sent_to_inapp')
    else
      flash[:notice] = I18n.t("active_admin.access_denied.message")
      redirect_back(fallback_location: active_admin_root) && return
    end
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
    r = {}
    begin
      filepath = Rails.root.join("lib", './sample-data.json')
      if File.exist?(filepath)
        file = File.read(filepath)
        json = JSON.parse(file)
        r = json.select { |a| a["uuid"] == params[:ada].to_i }
      end
    rescue
      r = {}
    end

    render json: r[0]
  end

  collection_action :create, method: :post do
    @application = build_resource
    @application.step = 1
    # Per salvarmi i precedente valore
    @application.store_version("step1")
    @application = build_desc(@application, "step1")
    if params["build_nested"] == "true"
      render('admin/page1', locals: { adas: adas, url: admin_applications_path }, layout: "active_admin") && return
    end
    if authorized?(ActiveAdmin::Auth::CREATE, @application)
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
    else
      flash[:notice] = I18n.t("active_admin.access_denied.message")
      redirect_back(fallback_location: active_admin_root) && return
    end
  end

  member_action :page1, method: :get do
    @application = Application.find_or_initialize_by(id: params[:id])
    if authorized?(ActiveAdmin::Auth::UPDATE, @application)
      url = @application.persisted? ? save_page1_admin_application_path(@application) : admin_applications_path
      @application.step = 1
      render template: 'admin/page1', locals: { adas: adas, url: url }, layout: "active_admin"
    else
      flash[:notice] = I18n.t("active_admin.access_denied.message")
      redirect_back(fallback_location: active_admin_root) && return
    end
  end

  member_action :save_page1, method: [:put, :patch] do
    @application = Application.find(params[:id])
    @application.step = 1
    # Per salvarmi i precedente valore
    @application.store_version("step1")
    @application = build_desc(@application, "step1")
    if params["build_nested"] == "true"
      url = @application.persisted? ? save_page1_admin_application_path(@application) : admin_applications_path
      render('admin/page1', locals: { adas: adas, url: url }, layout: "active_admin") && return
    end
    if authorized?(ActiveAdmin::Auth::UPDATE, @application)
      @application.assign_attributes(permitted_params.dig(:application) || {})
      @application.skip_validation = params[:commit] == I18n.t("active_admin.actions.application.save_without_validation")
      if @application.save
        if @application.skip_validation
          render template: 'admin/page1', locals: { adas: adas, url: save_page1_admin_application_path(@application) }, layout: "active_admin"
        else
          render template: 'admin/page2', locals: { url: save_page2_admin_application_path(@application) }, layout: "active_admin"
        end
      else
        render template: 'admin/page1', locals: { adas: adas, url: save_page1_admin_application_path(@application) }, layout: "active_admin"
      end
    else
      flash[:notice] = I18n.t("active_admin.access_denied.message")
      redirect_back(fallback_location: active_admin_root) && return
    end
  end

  member_action :page2, method: :get do
    @application = Application.find(params[:id])
    if authorized?(ActiveAdmin::Auth::UPDATE, @application)
      @application.step = 2
      render template: 'admin/page2', locals: { adas: adas, url: save_page2_admin_application_path(@application) }, layout: "active_admin"
    else
      flash[:notice] = I18n.t("active_admin.access_denied.message")
      redirect_back(fallback_location: active_admin_root) && return
    end
  end

  member_action :save_page2, method: [:put, :patch] do
    @application = Application.find(params[:id])
    if authorized?(ActiveAdmin::Auth::UPDATE, @application)
      @application.step = 2
      # Per salvarmi i precedente valore
      @application.store_version("step2")
      @application.assign_attributes(permitted_params.dig(:application) || {})
      # @application.skip_validation = params[:commit] == I18n.t("active_admin.actions.application.save_without_validation")
      if @application.save
        # if @application.skip_validation
        #   render template: 'admin/page2', locals: { url: save_page2_admin_application_path(@application) }, layout: "active_admin"
        # else
        #   @application.learning_opportunities.blank? ? @application.learning_opportunities.build : []
        #   render template: 'admin/page3', locals: { url: save_page3_admin_application_path(@application) }, layout: "active_admin"
        # end
        @application.complete!
        redirect_to admin_applications_path, notice: I18n.t('active_admin.applications.sent_to_review')

      else
        render template: 'admin/page2', locals: { url: save_page2_admin_application_path(@application) }, layout: "active_admin"
      end
    else
      flash[:notice] = I18n.t("active_admin.access_denied.message")
      redirect_back(fallback_location: active_admin_root) && return
    end
  end

  member_action :page3, method: :get do
    @application = Application.find(params[:id])
    if authorized?(:learning_opportunity, @application)
      @application.learning_opportunities.blank? ? @application.learning_opportunities.build : []
      @application.step = 3
      render template: 'admin/page3', locals: { adas: adas, url: save_page3_admin_application_path(@application) }, layout: "active_admin"
    else
      flash[:notice] = I18n.t("active_admin.access_denied.message")
      redirect_back(fallback_location: active_admin_root) && return
    end
  end

  member_action :save_page3, method: [:put, :patch] do
    @application = Application.find(params[:id])
    if authorized?(:learning_opportunity, @application)
      @application.step = 3
      # Per salvarmi i precedente valore
      # @application.store_version("step3")
      @application.assign_attributes(permitted_params.dig(:application) || {})
      if @application.save
        redirect_to admin_applications_path, notice: I18n.t('active_admin.applications.sent_learning')
      else
        @application.learning_opportunities.blank? ? @application.learning_opportunities.build : []
        render template: 'admin/page3', locals: { url: save_page3_admin_application_path(@application) }, layout: "active_admin"
      end
    else
      flash[:notice] = I18n.t("active_admin.access_denied.message")
      redirect_back(fallback_location: active_admin_root) && return
    end
  end

  member_action :update1, method: [:put, :patch] do
    @application = Application.find(params[:id])
    @application.step = 1
    # Per salvarmi i precedente valore
    @application.store_version("step1")
    @application = build_desc(@application, "step1")
    if params["build_nested"] == "true"
      render('admin/page1', locals: { adas: adas, url: save_page1_admin_application_path(@application) }, layout: "active_admin") && return
    end
    if authorized?(ActiveAdmin::Auth::UPDATE, @application)
      @application.assign_attributes(permitted_params.dig(:application) || {})
      @application.skip_validation = params[:commit] == I18n.t("active_admin.actions.application.save_without_validation")
      if @application.save
        if @application.skip_validation
          render 'admin/page1', locals: { adas: adas, url: save_page1_admin_application_path(@application) }, layout: "active_admin"
        else
          render template: 'admin/page2', locals: { url: save_page2_admin_application_path(@application) }, layout: "active_admin"
        end
      else
        render 'admin/page1', locals: { adas: adas, url: save_page1_admin_application_path(@application) }, layout: "active_admin"
      end
    else
      flash[:notice] = I18n.t("active_admin.access_denied.message")
      redirect_back(fallback_location: active_admin_root) && return
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
    expired = Application.expired
    if current_admin_user.super_admin? || current_admin_user.level_2? || current_admin_user.level_3?
      column '' do |a|
        if expired.include?(a)# && ((current_admin_user.level_2? && a.inapp?) || (current_admin_user.level_3? && (a.completed? || a.reviewed?)) || current_admin_user.super_admin?)
          ('<span class="fa-2x" style="color: #fc6f03;" title="' + I18n.t("active_admin.applications.waiting") + I18n.localize(a.sent_at, format: I18n.t("date.formats.ruby_custom"))  + '"><i class="fa fa-clock-o"></i></span>').html_safe
        end
      end
    end
    actions do |a|
      links = ""
      if a.completed? && (current_admin_user.super_admin? || current_admin_user.level_3?)
        links += link_to t('active_admin.applications.take'), in_progress_admin_application_path(a)
      end
      if authorized?(:review, a)
        links += link_to t('active_admin.applications.review'), review_admin_application_path(a)
      end
      if authorized?(:learning_opportunity, a)
        links += link_to t('active_admin.applications.add_learning_opportunities'), page3_admin_application_path(a)
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
      # todo: add competence ecc
      translate_attributes_table_with_label_for application do
        row :title
        row :url
        # row :description do |r|
        #   r.description
        # end
      end
      row :region do |a|
        a.region.try(:name)
      end
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
      if application.learning_opportunities.present?
        row :learning_opportunities do
          table_for application.learning_opportunities do
            column :region do |a|
              a.region.try(:name)
            end
            column :province do |a|
              a.province.try(:name)
            end
            column :city do |a|
              a.city.try(:name)
            end
            column :duration
            column :institution
            column :manners
            column :start_at
            column :end_at
            column :url
            column :description
          end
        end
      end
      attributes_table_for application.competences do
        div class: "panel" do
          h3 "Compentenze"
          if application.competences && application.competences.count > 0
            application.competences.each do |competence|
              div class: "panel_contents" do
                div class: "attributes_table" do
                  table do
                    tr do
                      th("#{I18n.t("activerecord.attributes.competence.competence")}: #{competence.competence}", colspan: 3 )
                    end
                    tr do
                      th I18n.t("activerecord.models.knowledge", count: competence.knowledges.count)
                      th I18n.t("activerecord.models.ability", count: competence.abilities.count)
                      th I18n.t("activerecord.models.responsibility", count: competence.responsibilities.count)
                    end
                    tbody do
                      max = [competence.knowledges.count, competence.abilities.count, competence.responsibilities.count].max
                      max.times do |i|
                        tr do
                          td(competence.knowledges[i].try(:knowledge), width: '33%')
                          td(competence.abilities[i].try(:ability), width: '33%')
                          td(competence.responsibilities[i].try(:responsibility), width: '33%')
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end

      # row :expiration_date
      row :created_by
      row :created_at
      row :updated_at

    end

    active_admin_comments status: "integration_request"
    if (current_admin_user.super_admin? || current_admin_user.level_2? || current_admin_user.level_3?)
      active_admin_comments status: "inapp"
    end
    if ((resource.reviewed? && (resource.in_progress_by == current_admin_user || current_admin_user.super_admin?)))
      div do
        button t('active_admin.applications.integration_request'), class: "button integration_request"
        button t('active_admin.applications.accept'), class: "button accept"
      end
    end

    active_admin_comments status: "integration_form", show_only_form: true
    active_admin_comments status: "accept_form", show_only_form: true
    active_admin_comments status: "inapp_form", show_only_form: true

  end

  controller do

    def scoped_collection
      if params.dig("q", "sent_at_eq") == "Urgenti"
          super.expired
      else
        super
      end
    end

    def new
      @application = Application.new
      render template: 'admin/page1', locals: { adas: adas, url: admin_applications_path }, layout: "active_admin"
    end

    def build_desc(a, step)
      r = {}
      begin
        return a if params["build_nested"] != "true"
        filepath = Rails.root.join("lib", './sample-data.json')
        if File.exist?(filepath)
          file = File.read(filepath)
          json = JSON.parse(file)
          r = json.select { |a| a["uuid"] == params["application"]["atlante"].to_i }
        end

        result = r[0]
        # a.competences.destroy_all
        a.competences.each_with_index do |h, i|
          h.persisted? ? h.mark_for_destruction : a.competences.delete(h)
          h.abilities.each do |ha|
            ha.mark_for_destruction
          end
          h.knowledges.each do |hk|
            hk.mark_for_destruction
          end
          h.responsibilities.each do |hr|
            hr.mark_for_destruction
          end
        end
        a.translations.find_or_initialize_by(locale: 'it')
        begin
          u = a.translations.select{ |b| b.locale == :it }.first.title =  result["titolo"]
        rescue
          nil
        end
        a.translations.find_or_initialize_by(locale: 'en')
        a.atlante_title = result["titolo"]
        a.atlante_code = result["codice"]
        a.atlante_region = result["repertorio"]
        result["competenze"].each do |c|
          cc = a.competences.build(competence: c["titolo"], atlante_competence: c["titolo"], atlante_code_competence: c["codice"])
          c["abilita"].each do |a|
            cc.abilities.build(ability: a["titolo"], atlante_ability: c["titolo"], atlante_code_ability: c["codice"])
          end
          c["conoscenze"].each do |a|
            cc.knowledges.build(knowledge: a["titolo"], atlante_knowledge: c["titolo"], atlante_code_knowledge: c["codice"])
          end
        end
        a
      rescue
        a
      end
    end

    def edit
      @application = Application.find(permitted_params.dig(:id))
      @application.step = 1
      render template: 'admin/page1', locals: { adas: adas, url: update1_admin_application_path(@application) }, layout: "active_admin"
    end

    # def determine_active_admin_layout
    #   CUSTOM_ACTIONS.include?(params[:action].to_sym) ? false : super
    # end
    def adas
      @adas ||= begin
                  filepath = Rails.root.join("lib", './sample-data-ridotto.json')
                  if File.exist?(filepath)
                    file = File.read(filepath)
                    json = JSON.parse(file)
                    json.sort_by { |a| a["titolo"].strip }.map { |a| ["#{a["titolo"]} (Codice: #{a["codice"]}#{Rails.env.development? ? " - UUID #{a["uuid"]}" : ""})", a["uuid"]] }
                  end
                rescue
                  []
                end

    end

  end

end
