require 'uri'
module ApplicationHelper

  def render_languages
    content_tag :div, class: 'languages-container' do
      (I18n.locale != :it ? (link_to(add_param(request.original_url, :new_locale, :it)) { flag_icon(:it) }) : '').html_safe.concat(
        (I18n.locale != :en ? (link_to(add_param(request.original_url, :new_locale, :en)) { flag_icon(:gb) }) : '').html_safe
      )
    end
  end

  def add_param(url, param_name, param_value)
    uri = URI(url)
    params = URI.decode_www_form(uri.query || "") << [param_name, param_value]
    uri.query = URI.encode_www_form(params)
    uri.to_s
  end
end
