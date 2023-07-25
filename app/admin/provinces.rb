ActiveAdmin.register Province do

  menu parent: I18n.t("active_admin.menu.parents.administration"), if: proc { !current_admin_user.level_1? }
  permit_params :id, :name, :region_id

  filter :name

  index download_links: [:json] do
    selectable_column
    id_column
    column :name
    column :region
    actions
  end

  controller do
    def index
      index! do |format|
        format.json { render json: collection.ordered.reverse.as_json(methods: :name) }
      end
    end
  end

end
