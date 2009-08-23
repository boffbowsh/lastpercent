module ApplicationHelper
  def severity(type)
    ERROR_SEVERITY[type] rescue 1
  end
  
  def severity_name(severity)
    case severity
    when 2 then 'error'
    when 1 then 'warning'
    else 
      'info'
    end
  end
  
  def set_asset_class(asset)
    klass = []
    klass << 'asset'
    klass << asset.content_type.to_pretty_s if asset.content_type
    klass << 'slow' if asset.slow?
    klass << 'external' if asset.external?
    klass << cycle('odd', 'even')
    
    return klass.join(' ')
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  def breadcrumbs(*args)
    links = [link_to('Home', root_path)]
    links = links + args
    
    
    content_for :breadcrumbs do
      content_tag :ul, :id => 'breadcrumbs' do
        returning String.new do |s|
          links.each_with_index do |link, i|
            class_names = []  
            class_names << 'first' if link == links.first
            class_names << 'last' if link == links.last
            
            s << content_tag(:li, link, :class => class_names.join(' '))
          end
        end
      end
    end
  end
  
  def asset_response_code(asset)
    if asset.response_status
      case asset.response_status.to_s
      when /^[4|5]/
        class_name = 'error_codes'
      when /^[3]/
        class_name = 'redirection_codes'
      else
        class_name = 'success_codes'
      end
    
      link_to(asset.response_status, site_assets_path(asset.site, :response_status => asset.response_status), :class => class_name)    
    end
  end
  
  def split_digits(value)
    content_tag :span, value
  end
end
