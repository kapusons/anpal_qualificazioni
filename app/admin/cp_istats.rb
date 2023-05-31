ActiveAdmin.register CpIstat do

  menu parent: I18n.t("active_admin.menu.parents.administration")
  permit_params :id, :code, :description, :name

  filter :code
  filter :name
  filter :description

  index download_links: false do
    selectable_column
    id_column
    column :code
    column :name
    column :description
    actions
  end

end
