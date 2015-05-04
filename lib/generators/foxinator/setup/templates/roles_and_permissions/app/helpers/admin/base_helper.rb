module Admin::BaseHelper
    
  def event_css_class(event, options = {})
    defaults = { prefix: 'btn', separator: '-' }
    options = defaults.merge(options)
    
    css_scope = case event.to_sym
      when :activate then 'success'
      when :deactivate then 'danger'
      else 'default'
    end
    
    [options[:prefix], css_scope].join(options[:separator])
  end
  
  def status_css_class(status, options = {})
    defaults = { 
      prefix: 'label', 
      separator: '-' 
    }
    options = defaults.merge(options)
    
    css_scope = case status.to_sym
      when :active then 'success'
      when :inactive then 'danger'
      else 'default'
    end
    
    [options[:prefix], [options[:prefix], css_scope].join(options[:separator])]
  end
  
  def status_tag(status, options = {})
    defaults = { 
      resource_class: resource_class ,
      prefix: 'label', 
      separator: '-',
      size: 'small'
    }
    options = defaults.merge(options)
    
    content_tag :span, options[:resource_class].human_state_name(status), class: [options[:prefix], status_css_size(status), status_css_class(status, options)]
  end
  
  def status_css_size(status, options = {})
    defaults = {
      prefix: 'label', 
      separator: '-',
      size: 'small'
    }
    options = defaults.merge(options)
    
    [options[:prefix], options[:size]].join(options[:separator])
  end
    
  def permission_granted_to(*args, &block)
    return(block_given? ? '' : false) unless admin_signed_in?
    
    if access = current_admin.permitted_to?(*args) 
      block_given? ? capture(&block) : access
    else
      block_given? ? '' : access
    end    
  end
  
  def link_to(*args, &block)    
    return super unless admin_signed_in?
    
    options = block_given? ? args.first : args[1]
    path = case options
             when Array then polymorphic_url(options)
             else url_for(options)
           end
    
    super if current_admin.permitted_to?(path, args[2])
  end  
  
  def actions_cell_tag(resource)
    content_tag :td, class: 'actions-cell' do
      concat link_to(content_tag(:i, nil,  class: 'glyphicon glyphicon-trash'), [current_namespace, current_parent, resource], class: 'btn btn-danger btn-xs pull-right', method: :delete, data: { confirm: t('are_you_sure') })
      concat content_tag(:span, '&nbsp;'.html_safe, class: 'pull-right')
      concat link_to(content_tag(:i, nil, class: 'glyphicon glyphicon-pencil'), [:edit, current_namespace, current_parent, resource], class: 'btn btn-default btn-xs pull-right')
    end
  end
  
  def table_row(resource, field, value=nil)
    content_tag :tr do
      concat content_tag(:td, resource.class.human_attribute_name(field))
      value ? concat(content_tag(:td, value)) : concat(content_tag(:td, resource.send(field)))
    end
  end
  
  alias_method :tr, :table_row
  
  def current_asset_paths(options = {})
    defaults = { except: :application }
    options = defaults.merge(options)
    
    asset_paths = case options[:except]
      when Array then lookup_context.prefixes.reverse.except(*options[:except].map(&:to_s))
      when String, Symbol then lookup_context.prefixes.reverse.except(options[:except].to_s)
      else lookup_context.prefixes.reverse
    end
    
    asset_paths.except(*excludable_asset_paths)
  end
  
  def excludable_asset_paths
    cms_asset_paths + email_preview_asset_paths
  end
  
  def cms_asset_paths
    @cms_asset_paths ||= %w(sites layouts pages snippets files revisions).map do |filename|
      File.join('comfy', 'admin', 'cms', filename)
    end
  end
  
  def email_preview_asset_paths
    @email_preview_asset_paths ||= %w(emails).map do |filename|
      File.join('rails_email_preview', filename)
    end
  end
  
end
