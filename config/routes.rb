require 'sidekiq/web'

Rails.application.routes.draw do

  root to: redirect("/#{I18n.default_locale}"), as: :redirected_root

  scope ":locale", path_prefix: '/:locale' do
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)
    root to: 'admin/dashboard#index'
  end

  authenticate :admin_user, ->(user) { user.super_admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
end
