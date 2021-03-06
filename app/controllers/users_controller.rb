class UsersController < ApplicationController
  before_filter :require_user, :except => [:activate, :new, :create]
  before_filter :require_owner, :except => [:activate, :new, :create, :index]
  before_filter :require_admin, :only => :index

  make_resourceful do
    actions :all, :except => :create
    member_actions :delete
    
    response_for :create, :update do 
      flash[:notice] = 'User successfully saved'
      redirect_to edit_user_path
    end
  end

  def create
    @user = User.new(params[:user])
    @user.save do |result|
      if result
        if @user.openid_identifier?
          @user.activate!
          UserSession.create(:openid_identifier => @user.openid_identifier)
          flash[:notice] = "You are now logged in!"
          redirect_to login_path
        else
          @user.deliver_activation_instructions!
          flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
          redirect_to login_path
        end
      else
        render :action => :new
      end
    end
  end

  def activate
    @user = User.find_using_perishable_token(params[:activation_code], 1.week) || (raise Exception)
    if @user.activate!
      @user.deliver_activation_confirmation!
      flash[:notice] = "Your account has been activated."
      UserSession.create(@user)
      redirect_to sites_path
    else
      render :action => :new
    end
  end

  private

  def current_objects
    @current_object ||= current_model.paginate :page => params[:page]
  end

  def require_owner
    access_denied unless current_user.admin? ||  current_user == current_object
  end
end
