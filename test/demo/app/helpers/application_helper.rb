module ApplicationHelper
  
  def resource?
    params[:id].present?
  end

  def current_title
    title = if resource? && current_namespace != 'comfy'
      [resource_class.model_name.human, resource.id].join(' #')
    elsif current_namespace == 'comfy'
      t("comfy.admin.cms.#{controller_name}.#{action_name}.title") 
    elsif %w(dashboards).include?(controller_name)
      t('dashboard', default: 'Dashboard  ')
    elsif respond_to?(:resource_class) && resource_class
      resource_class.model_name.human(count: :other)
    elsif current_namespace == 'rails_email_preview'  
      'E-Mails'
    end
    
    [title, ComfortableMexicanSofa.config.cms_title].compact.join(' - ')
  end  
  
  def true_or_false(condition, options = {})
    content_tag(:i, nil, options.except(:class).merge(class: [true_or_false_css_class(condition), options[:class]]))
  end
  
  def value_or_false(value, options = {})
    value.present? ? value : true_or_false(false, options)
  end 
  
  def true_or_false_css_class(condition)
    condition ? 'glyphicon glyphicon-ok-circle text-success text-top' : 'glyphicon glyphicon-remove-circle text-danger text-top'
  end 
    
  def localize(*args)
    super if args.first.present?
  end
  
  alias_method :l, :localize
  
  def current_asset_paths(options = {})
    case options[:except]
      when Array then lookup_context.prefixes.reverse.except(*options[:except].map(&:to_s))
      when String, Symbol then lookup_context.prefixes.reverse.except(options[:except].to_s)
      else cpmtroller._prefixes.reverse
    end
  end
  
end
