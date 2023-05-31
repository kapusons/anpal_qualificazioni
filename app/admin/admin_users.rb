ActiveAdmin.register AdminUser do
  permit_params do
    params2 = [:email, :role, :name]
    params2 += [:password, :password_confirmation] if params.dig(:admin_user, :password).present? || params.dig(:admin_user, :password_confirmation).present?
    params2
  end

  menu parent: I18n.t("active_admin.menu.parents.administration"), if: proc {
    current_admin_user.super_admin? || current_admin_user.level_3?
  }

  index download_links: false do
    selectable_column
    id_column
    column :email
    column :name
    column :role do |u|
      AdminUser.human_enum_name(:role, u.role)
    end
    column :current_sign_in_at
    actions
  end

  filter :email
  filter :name
  filter :role, as: :select, collection: AdminUser.roles.to_a

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :password
      f.input :password_confirmation
      if current_admin_user.super_admin?
        f.input :role, as: :select, collection: AdminUser.roles.keys.to_a.reject{|a| !current_admin_user.super_admin? && a == "super_admin" }.map{ |a| [AdminUser.human_enum_name(:role, a), a] }, selected: f.object.role
      end
    end
    f.actions
  end

  show do
    attributes_table do
      row :email
      row :name
      if current_admin_user.super_admin?
        row :role do |u|
          AdminUser.human_enum_name(:role, u.role)
        end
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

  controller do

  end

end
