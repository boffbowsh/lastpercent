class UserSessionsController < ApplicationController
  make_resourceful do
    actions :new
  end

  def create
    @user_session = Session.new(params[:user_session])
    @user_session.save do |result|
       if result
         flash[:notice] = "Login successful!"
         redirect_back_or_default root_path
       else
         render :action => :new
       end
     end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = 'Logged out successfully'
    redirect_to root_path
  end
end