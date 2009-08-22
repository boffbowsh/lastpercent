ActionController::Base.append_view_path(File.join(directory, 'app/views'))
require 'clever_form'
ActionView::Base.send :include, CleverForm::CleverFormHelper