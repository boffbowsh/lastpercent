module ApplicationHelper
  def severity(type)
    ERROR_SEVERITY[type] rescue 1
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
end
