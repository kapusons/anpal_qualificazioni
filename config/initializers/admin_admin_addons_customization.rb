require 'activeadmin_addons/support/input_helpers/input_methods'
ActiveAdminAddons::InputMethods.module_eval do

  def input_value
    @input_value ||= (valid_object.send(valid_method) || @options[:selected])
  end

end