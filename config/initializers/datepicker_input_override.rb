ActiveAdmin::Inputs::DatepickerInput.class_eval do

  private

  def datepicker_options
    options = self.options.fetch(:datepicker_options, {})
    options = Hash[options.map { |k, v| [k.to_s.camelcase(:lower), v] }]
    options["altField"] = "##{dom_id.gsub('_date_selector', '')}#{options["altField"]}" if options["altField"] && options["altField"].match(/date_selector/)
    { datepicker_options: options }
  end
end