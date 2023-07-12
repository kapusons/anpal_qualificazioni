Formtastic::Inputs::Base::Stringish.module_eval do

  # @abstract Override this method in your input class to describe how the input should render itself.
  def to_html
    input_wrapping do
      label_html <<
        desc_html <<
        builder.text_field(method, input_html_options)
    end
  end

  def desc_html
    desc? ? template.content_tag(:p, desc_text.html_safe, class: 'input-desc') : "".html_safe
  end

  def desc?
    options[:desc] == true
  end

  def desc_text
    link = "<a href='#{I18n.t("activerecord.attributes.#{builder.model_name.underscore}.#{method}_link")}' target='_blank'>#{I18n.t("activerecord.attributes.#{builder.model_name.underscore}.#{method}_link_label")}</a>".html_safe rescue nil
    I18n.t("activerecord.attributes.#{builder.model_name.underscore}.#{method}_desc", link: link ? link : '') || ''
  end
end