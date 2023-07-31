ActiveAdmin::Views::Header.class_eval do

  def build(namespace, menu)
    super(id: "header")

    @namespace = namespace
    @menu = menu
    @utility_menu = @namespace.fetch_menu(:utility_navigation)
    # @language_navigation = @namespace.fetch_menu(:language_navigation)

    site_title @namespace
    global_navigation @menu, class: "header-item tabs"
    div render_languages, class: 'wrapper-languages'
    utility_navigation @utility_menu, id: "utility_nav", class: "header-item tabs"
  end

end