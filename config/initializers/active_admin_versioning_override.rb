ActiveAdminVersioning::PaperTrail::VersionConcern.module_eval do
  def item_column_names
    item_class.column_names
  end

  def item_attributes
    YAML.load(object, permitted_classes: [Time, Date]
    ).slice(*item_column_names)
  end

end