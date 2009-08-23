class SitesController < ApplicationController
  before_filter :require_user
  
  make_resourceful do
    actions :all

    publish :xml, :json, :attributes => [:id, :url, :assets_count, :errors_count, {:user => [:id, :name]}]
  end

  private

  def current_model
    current_user.sites
  end

  def current_objects
    @current_object ||= current_model.paginate  :page => params[:page], :include => :assets
  end
end