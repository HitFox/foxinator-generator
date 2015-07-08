module SortHelper
  
  def table_head(*args, &block)
    options = args.last.kind_of?(Hash) && args.last.extractable_options? ? args.last : {}
    
    defaults = { resource_class: respond_to?(:resource_class) ? resource_class : nil }
    options = defaults.merge(options)
    
    args.last.kind_of?(Hash) && args.last.extractable_options? ? args[-1] == options : args << options
    
    column = Column.new(*args, &block)    
    sort_key = column.sortable? && column.sort_key
    opposite_sort_key = sort_key && current_sort[0] == sort_key ? current_sort[1] == 'desc' ? 'asc' : 'desc' : 'desc'
    classes = []
    classes << 'sortable'
    classes << "sorted-#{sort_key && current_sort[0] == sort_key ? current_sort[1] : 'asc'}" if sort_key && current_sort[0] == sort_key
    classes << "opposite-sorted-#{opposite_sort_key}" if sort_key && current_sort[0] == sort_key
    classes << options[:class]
    classes << column.html_class
    classes_string = classes.join(' ')
    
    content_tag :th do
      if sort_key && column.sortable?
        concat link_to(column.pretty_title.html_safe, params.merge(order: "#{sort_key}_#{order_for_sort_key(sort_key)}").except(:page))
        concat content_tag(:div, nil, class: classes)
      else
        concat column.pretty_title.html_safe
      end
    end
  end
  
  alias_method :th, :table_head
  
  def order_for_sort_key(sort_key)
    current_key, current_order = current_sort
    return 'desc' unless current_key == sort_key
    current_order == 'desc' ? 'asc' : 'desc'
  end
  
  def current_sort
    @current_sort ||= if params[:order] && params[:order] =~ /^([\w\_\.]+)_(desc|asc)$/
      [$1,$2]
    else
      []
    end
  end
  
  class Column

    attr_accessor :title, :data , :html_class

    def initialize(*args, &block)
      @options = args.extract_options!      
      @title = args[0]
      @html_class = @options.delete(:class) || @title.to_s.downcase.underscore.gsub(/ +/,'_')
      @data  = args[1] || args[0]
      @data = block if block
      @resource_class = @options[:resource_class]
    end

    def sortable?
      if @data.kind_of?(Proc)
        [String, Symbol].include?(@options[:sortable].class)
      elsif @options.has_key?(:sortable)
        @options[:sortable]
      elsif @data.respond_to?(:to_sym) && @resource_class
        !@resource_class.reflect_on_association(@data.to_sym)
      else
        true
      end
    end

    def sort_key
      if @options[:sortable] == true || @options[:sortable] == false || @options[:sortable].nil?
        @data.to_s
      else
        @options[:sortable].to_s
      end
    end

    def pretty_title
      if @title.kind_of?(Symbol) ||  @title.kind_of?(String)
        default_title =  @title.to_s.titleize

        @title = if @options[:i18n]
          t(@options[:i18n])
        elsif @options[:name]
          @resource_class.human_attribute_name(@options[:name])
        elsif @options[:title]
          @options[:title]
        elsif @resource_class  
          @resource_class.human_attribute_name(@title)
        else
          default_title
        end
      else
        @title
      end
    end
  end
end
