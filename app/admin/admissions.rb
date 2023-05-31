ActiveAdmin.register Admission do

  permit_params :id, :name
  menu parent: I18n.t("active_admin.menu.parents.administration")

  filter :name

end
