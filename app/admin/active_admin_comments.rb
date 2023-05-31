ActiveAdmin.register ActiveAdmin::Comment do

  menu parent: I18n.t("active_admin.menu.parents.administration"), if: proc {
    current_admin_user.super_admin? || current_admin_user.level_3?
  }

  filter :body
  filter :author_of_AdminUser_type_id_eq, as: :select, collection: -> { AdminUser.all.map{ |a| [a.email, a.id] } }, label:  I18n.t("active_admin.filters.location.author_of_AdminUser_type_id_eq")
  
end
