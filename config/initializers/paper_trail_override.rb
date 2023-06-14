PaperTrail::Events::Base.class_eval do

  private

  # @api private
  def nonskipped_attributes_before_change(is_touch)
    record_attributes = @record.attributes.except(*calculate_skipped_array)
    record_attributes.each_key do |k|
      if @record.class.column_names.include?(k)
        record_attributes[k] = attribute_in_previous_version(k, is_touch)
      end
      # if @record.respond_to?(:translations)

    end
  end

  # @api private
  def changed_and_not_ignored
    skip = @record.paper_trail_options[:skip]
    (changed_in_latest_version - calculated_ignored_array) - skip
  end

  def ignored_attr_has_changed?
    ignored = calculated_ignored_array + @record.paper_trail_options[:skip]
    ignored.any? && (changed_in_latest_version & ignored).any?
  end

  def calculate_skipped_array
    skip = @record.paper_trail_options[:skip].dup
    skip.delete_if do |obj|
      obj.is_a?(Hash) &&
        obj.each { |attr, condition|
          skip << attr if condition.respond_to?(:call) && condition.call(@record)
        }
    end
  end

end
