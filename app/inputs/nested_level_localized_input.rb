# ActiveAdminAddons::Rails::Engine.root.join('app', 'inputs', 'nested_level_input')

class NestedLevelLocalizedInput < NestedLevelInput

  private

  def url_from_method
    url = ["/#{I18n.locale}/"] # patch per la locale

    if ActiveAdmin.application.default_namespace.present?
      url << "#{ActiveAdmin.application.default_namespace}/"
    end

    url << tableize_method
    url.join("")
  end

end
