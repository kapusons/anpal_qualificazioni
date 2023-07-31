class ApplicationController < ActionController::Base

  before_action :set_default_locale
  helper ApplicationHelper

  private

  def set_default_locale
    if params[:new_locale] && I18n.available_locales.include?(params[:new_locale].to_sym)
      I18n.locale = params[:new_locale].try(:to_sym) || I18n.default_locale
      redirect_to(params.merge(locale: I18n.locale).permit(:locale, :controller, :action)) && return
    else
      I18n.locale = params[:locale].try(:to_sym) || session[:locale] || I18n.default_locale
    end
  end

  def default_url_options(options={})
    { :locale => I18n.locale }
  end

  def after_sign_out_path_for(resource_or_scope)
    "/#{I18n.locale}"
  end

  def after_sign_in_path_for(resource_or_scope)
    signed_in_root_path(resource_or_scope)
  end

  def signed_in_root_path(resource_or_scope)
    "/#{I18n.locale}"
  end

end
