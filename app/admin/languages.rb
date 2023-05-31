ActiveAdmin.register Language do

  menu parent: I18n.t("active_admin.menu.parents.administration")
  permit_params :id, :name, :code

  filter :name
  filter :code_eq, as: :select, collection: -> { Language.all.map{ |a| [a.name, a.code] } }, label:  I18n.t("active_admin.filters.location.code_eq")

  index download_links: false do
    selectable_column
    id_column
    column :name
    column :code
    actions
  end

end
