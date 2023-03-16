ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation, :role

  menu parent: I18n.t("active_admin.menu.parents.administration")

  index download_links: false do
    selectable_column
    id_column
    column :email
    column :role
    column :current_sign_in_at
    actions
  end

  filter :email
  filter :role, as: :select, collection: AdminUser.roles.to_a

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      if current_admin_user.super_admin?
        f.input :role, as: :select, collection: AdminUser.roles.keys.to_a.reject{|a| !current_admin_user.super_admin? && a == "super_admin" }, selected: f.object.role
      end
    end
    f.actions
  end

  show do
    attributes_table do
      row :email
      if current_admin_user.super_admin?
        row :role
        row :institution
        row :reset_password_token
        row :reset_password_sent_at
        row :remember_created_at
        row :current_sign_in_at
        row :last_sign_in_at
        row :current_sign_in_ip
        row :last_sign_in_ip
        row :created_at
        row :updated_at
      end
    end
  end

end
