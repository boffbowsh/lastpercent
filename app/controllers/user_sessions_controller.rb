class UserSessionsController < ApplicationController
  # TODO: [Pete] This makes me feel slighty ill
  before_filter :set_body_id, :only => [:new, :create]  
  
  make_resourceful do
    actions :new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    @user_session.save do |result|
      if result
        flash[:notice] = "Login successful!"
        
        return redirect_to(new_site_path(:site_url => session[:site_url])) if session[:site_url]
        redirect_back_or_default sites_path
      else
        flash.now[:error] = "Please enter a valid email and password"
        render :action => :new
      end
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = 'Logged out successfully'
    redirect_to login_path
  end
  
  private
  
  def set_body_id
    @body_id = 'login_or_signup'
  end
end