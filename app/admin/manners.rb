ActiveAdmin.register Manner do

  menu parent: I18n.t("active_admin.menu.parents.administration")
  permit_params :id, :name

  filter :name

  index download_links: false do
    selectable_column
    id_column
    column :name
    column :siu_id
    column :parent
    actions
  end

end
