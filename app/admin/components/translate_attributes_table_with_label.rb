module ActiveAdmin
  module Translate

    # Adds a builder method `translate_attributes_table_for` to build a
    # table with translations for a model that has been localized with
    # Globalize.
    #
    class TranslateAttributesTableWithLabel < ::ActiveAdmin::Views::AttributesTable

      builder_method :translate_attributes_table_with_label_for

      def row(attr, label = '', &block)
        ::I18n.available_locales.each_with_index do |locale, index|
          @table << tr(class: "row row-#{attr.to_s}") do
            if index == 0
              th :rowspan => ::I18n.available_locales.length do
                header_content_for(attr)
              end
            end
            @collection.each do |record|
              td(width: 60) do
                strong do
                  "#{locale.to_s}"
                end
              end
              td do
                if block_given?
                  block.call(@collection.first, resource, locale.to_s)
                else
                  resource.translation_for(locale).send(attr) || empty_value
                end

              end
            end
          end
        end
      end

      protected

      def default_id_for_prefix
        'attributes_table'
      end

      def default_class_name
        'attributes_table'
      end

    end
  end
end
