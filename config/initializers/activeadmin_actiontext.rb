ActiveAdmin::ViewHelpers::DisplayHelper.module_eval do

  def pretty_format(object)
    case object
    when String, Numeric, Symbol, Arbre::Element, ActionText::RichText
      object.to_s
    when Date, Time
      I18n.localize object, format: active_admin_application.localize_format
    when Array
      format_collection(object)
    else
      if defined?(::ActiveRecord) && object.is_a?(ActiveRecord::Base) ||
        defined?(::Mongoid) && object.class.include?(Mongoid::Document)
        auto_link object
      elsif defined?(::ActiveRecord) && object.is_a?(ActiveRecord::Relation)
        format_collection(object)
      else
        display_name object
      end
    end
  end
end
