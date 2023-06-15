ActiveAdmin::Comments::Views::Comments.class_eval do
  builder_method :active_admin_comments_for

  attr_accessor :resource, :options

  def build(resource, options = {})
    @options = options
    @resource = resource
    if is_integration_request?
      @comments = active_admin_authorization.scope_collection(ActiveAdmin::Comment.find_for_resource_in_namespace(resource, active_admin_namespace.name).includes(:author).where(status: "integration_request"))
    elsif is_acceptance_request?
      @comments = active_admin_authorization.scope_collection(ActiveAdmin::Comment.find_for_resource_in_namespace(resource, active_admin_namespace.name).includes(:author).where(status: "accept"))
    else
      @comments = active_admin_authorization.scope_collection(ActiveAdmin::Comment.find_for_resource_in_namespace(resource, active_admin_namespace.name).includes(:author).where(status: "inapp"))
    end

    add_class options[:status]

    if options[:show_only_form]
      if resource.reviewed? && (resource.in_progress_by == current_admin_user || current_admin_user.super_admin?) && !is_inapp_request?
        super(form_title, for: resource)
        build_comment_form
      end
      if resource.inapp? && current_admin_user.level_2?
        super(form_title, for: resource)
        build_comment_form
      end
    else
      if is_integration_request? && resource.comments.where(status: 'integration_request').count > 0
        super(title, for: resource)
        build_comments
      end
      if is_inapp_request? && resource.comments.where(status: 'inapp').count > 0 && (current_admin_user.super_admin? || current_admin_user.level_2? || current_admin_user.level_3?)
        super(title, for: resource)
        build_comments
      end
    end
  end

  def is_integration_request?
    options[:status] == "integration_request" || options[:status] == "integration_form"
  end

  def is_acceptance_request?
    options[:status] == "accept" || options[:status] == "accept_form"
  end

  def is_inapp_request?
    options[:status] == "inapp" || options[:status] == "inapp_form"
  end

  protected

  def title
    if is_integration_request?
      I18n.t "active_admin.comments.integration_request_title_content"
    elsif is_acceptance_request? && current_admin_user.level_2?
      # I18n.t "active_admin.comments.accept_level_2_title_content"
      ""
    elsif is_acceptance_request?
      I18n.t "active_admin.comments.accept_title_content"
    elsif is_inapp_request?
      I18n.t "active_admin.comments.inapp_title_content"
    else
      I18n.t "active_admin.comments.title_content", count: @comments.total_count
    end
  end

  def form_title
    if is_integration_request?
      I18n.t "active_admin.comments.in_integration_request_title_content"
    elsif is_acceptance_request? && current_admin_user.level_2?
      I18n.t "active_admin.comments.accept_level_2_title_content"
    elsif is_acceptance_request?
      I18n.t "active_admin.comments.accept_title_content"
    elsif is_inapp_request?
      I18n.t "active_admin.comments.inapp_title_content"
    else
      I18n.t "active_admin.comments.title_content", count: @comments.total_count
    end
  end

  def build_comments
    if @comments.any?
      @comments.each(&method(:build_comment))
      # div page_entries_info(@comments).html_safe, class: "pagination_information"
      # div I18n.t("active_admin.comments.all_requests"), class: "pagination_information" unless current_admin_user.level_1?
    else
      # build_empty_message
    end

    # text_node paginate @comments

    # if authorized?(ActiveAdmin::Auth::CREATE, ActiveAdmin::Comment) && @show_form
    #   build_comment_form
    # end
  end

  def build_comment(comment)
    div for: comment do
      div class: "active_admin_comment_meta" do
        h4 class: "active_admin_comment_author" do
          comment.author ? auto_link(comment.author) : I18n.t("active_admin.comments.author_missing")
        end
        span pretty_format comment.created_at
        if authorized?(ActiveAdmin::Auth::DESTROY, comment)
          text_node link_to I18n.t("active_admin.comments.delete"), comments_url(comment.id), method: :delete, data: { confirm: I18n.t("active_admin.comments.delete_confirmation") }
        end
      end
      div class: "active_admin_comment_body" do
        simple_format comment.body
      end
    end
  end

  def build_empty_message
    span I18n.t("active_admin.comments.no_comments_yet"), class: "empty"
  end

  def comments_url(*args)
    parts = []
    parts << active_admin_namespace.name unless active_admin_namespace.root?
    parts << active_admin_namespace.comments_registration_name.underscore
    parts << "path"
    send parts.join("_"), *args
  end

  def comment_form_url
    parts = []
    parts << active_admin_namespace.name unless active_admin_namespace.root?
    parts << active_admin_namespace.comments_registration_name.underscore.pluralize
    parts << "path"
    send parts.join "_"
  end

  def build_comment_form
    active_admin_form_for(ActiveAdmin::Comment.new, url: comment_form_url) do |f|
      f.inputs do
        f.input :resource_type, as: :hidden, input_html: { value: ActiveAdmin::Comment.resource_type(parent.resource) }
        f.input :resource_id, as: :hidden, input_html: { value: parent.resource.id }
        f.input :status, as: :hidden, input_html: { value: self.parent.options[:status] == "integration_form" ? "integration_request" : (self.parent.options[:status] == "accept_form" ? "accept" : "inapp") }
        f.input :body, label: false, input_html: { size: "80x8" }
      end

      f.actions do
        if resource.reviewed?
          if self.parent.is_integration_request? && (current_admin_user.super_admin? || current_admin_user.level_3?)
            f.action :submit, label: I18n.t("active_admin.comments.send_integration_request")
          elsif self.parent.is_acceptance_request? && (current_admin_user.super_admin? || current_admin_user.level_3?)
            f.action :submit, label: I18n.t("active_admin.comments.send_acceptance_request_with_advice")
            span "     "
            f.action :submit, label: I18n.t("active_admin.comments.send_acceptance_request")
          elsif self.parent.is_integration_request? && (current_admin_user.super_admin? || current_admin_user.level_2?)
            f.action :submit, label: I18n.t("active_admin.comments.send_integration_request")
          elsif self.parent.is_acceptance_request? && (current_admin_user.super_admin? || current_admin_user.level_2?)
            f.action :submit, label: I18n.t("active_admin.comments.send_acceptance_review")
          end
        elsif resource.inapp?
          f.action :submit, label: I18n.t("active_admin.comments.send_opinion")
        else
          f.action :submit, label: I18n.t("active_admin.comments.add")
        end

      end
    end
  end

  def default_id_for_prefix
    "active_admin_comments_for"
  end

end
