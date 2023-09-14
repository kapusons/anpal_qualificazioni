# frozen_string_literal: true
module ActiveAdmin
  module Views
    class TableForVersioning < ::ActiveAdmin::Views::AttributesTable
      builder_method :table_for_versioning

      def tag_name
        "table"
      end

      def build(obj, *attrs)
        options = attrs.extract_options!
        @sortable = options.delete(:sortable)
        new_obj = nil
        id = 0
        els = {}
        obj.reverse.each do |a|
          els[id] = [] if els[id].nil?
          els[id] << a
          id += 1 if a.event == "step2"
        end
        last_key = els.keys.max
        if els[last_key].respond_to?(:each)
          els[last_key].reverse.each do |co|
            if new_obj.nil?
              new_obj = co
              next
            end
            new_obj.object = YAML.dump(YAML.load(new_obj.object, permitted_classes: [Time, Date]).merge(YAML.load(co.object, permitted_classes: [Time, Date])))
            d = nil
            if co.event == "step1"
              hash = { }
              f = co.meta_objects.slice("desc", "title", "url").delete_if {  |k, v| v.empty? || v.all?{ |a| a.blank? } }
              # d = co.meta_objects.slice("desc").delete_if {  |k, v| v.empty? || v.all?{ |a| a.blank? } }.try(:[], "desc")
              hash = f if f.present?
            elsif co.event == "step2"
              hash = co.meta_objects.slice("ateco_ids", "cp_istat_ids", "isced_ids")
            else
              hash = { }
            end
            # new_obj.meta_objects["desc"] = [] if new_obj.meta_objects["desc"].nil?
            # new_obj.meta_objects["desc"] += d if d.present?
            new_obj.meta_objects.merge!(hash)
          end
        end

        obj = new_obj if new_obj.present?
        @collection = obj.respond_to?(:each) && !obj.is_a?(Hash) ? obj : [obj]
        @resource_class = options.delete(:i18n)
        @resource_class ||= @collection.klass if @collection.respond_to? :klass

        @columns = []
        @row_class = options.delete(:row_class)

        # super(options)
        @table = table
        build_colgroups
        rows(*attrs)
      end

      def rows(*attrs)
        attrs.each do |attr|
          row(attr)
        end
      end

      def row(*args, &block)
        title = args[0]
        options = args.extract_options!
        classes = [:row]
        if options[:class]
          classes << options[:class]
        elsif title.present?
          classes << "row-#{title.to_s.parameterize(separator: "_")}"
        end
        options[:class] = classes.join(" ")

        @table << tr(options) do
          th do
            header_content_for(title)
          end
          @collection.each do |record|
            td(width: 60) do
              if ::Application.translated_attribute_names.include?(title)
                strong do
                  "#{locale.to_s}"
                end
              end
            end
            td do
              if block_given?
                block.call(@collection.first, resource, locale.to_s)
              else
                # resource.translation_for(locale).send(attr) || empty_value
                content_for(record, block || title)
              end

            end
          end
        end
      end
      def header_content_for(attr)
        if @resource_class.respond_to?(:human_attribute_name)
          @resource_class.human_attribute_name(attr, default: attr.to_s.titleize)
        else
          attr.to_s.titleize
        end
      end


      def columns(*attrs)
        attrs.each { |attr| column(attr) }
      end

      def column(*args, &block)
        options = default_options.merge(args.extract_options!)
        title = args[0]
        data = args[1] || args[0]

        col = Column.new(title, data, @resource_class, options, &block)
        @columns << col

        # Build our header item
        within @header_row do
          build_table_header(col)
        end

        # Add a table cell for each item
        @collection.each_with_index do |resource, index|
          within @tbody.children[index] do
            build_table_cell col, resource
          end
        end
      end

      def sortable?
        !!@sortable
      end

      protected

      def build_table
        build_table_head
        build_table_body
      end

      def build_table_head
        @thead = thead do
          @header_row = tr
        end
      end

      def build_table_header(col)
        classes = Arbre::HTML::ClassList.new
        sort_key = sortable? && col.sortable? && col.sort_key
        params = request.query_parameters.except :page, :order, :commit, :format

        classes << "sortable" if sort_key
        classes << "sorted-#{current_sort[1]}" if sort_key && current_sort[0] == sort_key
        classes << col.html_class

        if sort_key
          th class: classes do
            link_to col.pretty_title, params: params, order: "#{sort_key}_#{order_for_sort_key(sort_key)}"
          end
        else
          th col.pretty_title, class: classes
        end
      end

      def build_table_body
        @tbody = tbody do
          # Build enough rows for our collection
          @collection.each do |elem|
            classes = [helpers.cycle("odd", "even")]

            if @row_class
              classes << @row_class.call(elem)
            end

            tr(class: classes.flatten.join(" "), id: dom_id_for(elem))
          end
        end
      end

      def build_table_cell(col, resource)
        td class: col.html_class do
          html = helpers.format_attribute(resource, col.data)
          # Don't add the same Arbre twice, while still allowing format_attribute to call status_tag
          current_arbre_element << html unless current_arbre_element.children.include? html
        end
      end

      # Returns an array for the current sort order
      #   current_sort[0] #=> sort_key
      #   current_sort[1] #=> asc | desc
      def current_sort
        @current_sort ||= begin
          order_clause = active_admin_config.order_clause.new(active_admin_config, params[:order])

          if order_clause.valid?
            [order_clause.field, order_clause.order]
          else
            []
          end
        end
      end

      # Returns the order to use for a given sort key
      #
      # Default is to use 'desc'. If the current sort key is
      # 'desc' it will return 'asc'
      def order_for_sort_key(sort_key)
        current_key, current_order = current_sort
        return "desc" unless current_key == sort_key
        current_order == "desc" ? "asc" : "desc"
      end

      def default_options
        {
          i18n: @resource_class
        }
      end

      class Column

        attr_accessor :title, :data, :html_class

        def initialize(*args, &block)
          @options = args.extract_options!

          @title = args[0]
          html_classes = [:col]
          if @options.has_key?(:class)
            html_classes << @options.delete(:class)
          elsif @title.present?
            html_classes << "col-#{@title.to_s.parameterize(separator: "_")}"
          end
          @html_class = html_classes.join(" ")
          @data = args[1] || args[0]
          @data = block if block
          @resource_class = args[2]
        end

        def sortable?
          if @options.has_key?(:sortable)
            !!@options[:sortable]
          elsif @resource_class
            @resource_class.column_names.include?(sort_column_name)
          else
            @title.present?
          end
        end

        #
        # Returns the key to be used for sorting this column
        #
        # Defaults to the column's method if its a symbol
        #   column :username
        #   # => Sort key will be set to 'username'
        #
        # You can set the sort key by passing a string or symbol
        # to the sortable option:
        #   column :username, sortable: 'other_column_to_sort_on'
        #
        def sort_key
          # If boolean or nil, use the default sort key.
          if @options[:sortable].nil? || @options[:sortable] == true || @options[:sortable] == false
            sort_column_name
          else
            @options[:sortable].to_s
          end
        end

        def pretty_title
          if @title.is_a? Symbol
            default = @title.to_s.titleize
            if @options[:i18n].respond_to? :human_attribute_name
              @title = @options[:i18n].human_attribute_name @title, default: default
            else
              default
            end
          else
            @title
          end
        end

        private

        def sort_column_name
          @data.is_a?(Symbol) ? @data.to_s : @title.to_s
        end
      end
    end
  end
end
