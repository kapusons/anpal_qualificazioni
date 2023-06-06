# frozen_string_literal: true
ActiveAdmin::Views::Pages::Base.class_eval do

  private

  def build_active_admin_head
    within head do
      html_title [title, helpers.active_admin_namespace.site_title(self)].compact.join(" | ")

      text_node(active_admin_namespace.head)

      active_admin_application.stylesheets.each do |style, options|
        stylesheet_tag = active_admin_namespace.use_webpacker ? stylesheet_pack_tag(style, **options) : stylesheet_link_tag(style, **options)
        text_node(stylesheet_tag.html_safe) if stylesheet_tag
      end

      active_admin_namespace.meta_tags.each do |name, content|
        text_node(meta(name: name, content: content))
      end

      active_admin_application.javascripts.each do |path|
        javascript_tag = active_admin_namespace.use_webpacker ? javascript_pack_tag(path) : javascript_include_tag(path)
        text_node(javascript_tag)
      end

      # Patch to include ECMA6
      text_node(javascript_importmap_tags "active_admin_ecma6")

      if active_admin_namespace.favicon
        favicon = active_admin_namespace.favicon
        favicon_tag = active_admin_namespace.use_webpacker ? favicon_pack_tag(favicon) : favicon_link_tag(favicon)
        text_node(favicon_tag)
      end

      text_node csrf_meta_tag
    end
  end
end


ActiveAdmin::ResourceCollection.class_eval do

  # Override to customize ActiveResource of Comment
  def add(resource)
    if match = @collection[resource.resource_name]
      if resource.resource_name == "Comment"
        @collection[resource.resource_name] = resource
      else
        raise_if_mismatched! match, resource
        match
      end
    else
      @collection[resource.resource_name] = resource
    end
  end

end