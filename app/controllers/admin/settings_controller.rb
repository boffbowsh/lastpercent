class Admin::SettingsController < Admin::ApplicationController
  def index
    @settings = Settings.all
  end
  
  def update
    if request.post?
      if params[:settings]
        params[:settings].each do |s|
          Settings[s.first] = s.second
        end
      end
      flash[:notice] = 'Settings Updated'
    end
    redirect_to admin_settings_path
  end
end