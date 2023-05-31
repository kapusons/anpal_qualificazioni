ActiveAdmin.register Ateco do

  menu parent: I18n.t("active_admin.menu.parents.administration")
  permit_params :id, :code, :description, :code_micro, :description_micro, :code_category, :description_category

  filter :code
  filter :code_category
  filter :code_micro
  filter :description
  filter :description_category
  filter :description_micro

  index download_links: false do
    selectable_column
    id_column
    column :code
    column :code_category
    column :description_category
    actions
  end

end
