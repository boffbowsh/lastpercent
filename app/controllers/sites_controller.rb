class SitesController < ApplicationController
  before_filter :require_user
  before_filter :require_owner, :except => [:index, :create, :new]
  
  make_resourceful do
    actions :all

    publish :xml, :json, :attributes => [:id, :url, :spider_failed_at, :spider_ended_at, :assets_count, :errors_count, :warnings_count, :successes_count, {:user => [:id, :name]}]
    
    before :new do
      @current_object.url = params[:site_url] if params[:site_url]
    end
    
    response_for :destroy do 
      flash[:notice] = 'Site was successfully removed'
      redirect_to sites_path
    end
  end

  private

  def current_model
    current_user.sites
  end

  def current_objects
    @current_object ||= current_model.paginate  :page => params[:page], :include => :assets
  end
  
  def require_owner
    access_denied unless current_user.admin? || current_user == current_object.user
  end
end