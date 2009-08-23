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
end
