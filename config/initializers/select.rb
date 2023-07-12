Formtastic::Inputs::SelectInput.class_eval do

  def to_html
    input_wrapping do
      label_html <<
        desc_html <<
        select_html
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