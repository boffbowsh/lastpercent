class SitesController < ApplicationController
  before_filter :require_user, :except => [:index, :show]
  
  make_resourceful do
    actions :all

    publish :xml, :json, :attributes => [:id, :url, {:user => [:id, :name]}]
    
    before :create do
      current_object.user = current_user
    end
  end

  private

  def current_objects
    @current_object ||= current_model.paginate  :page => params[:page]
  end
end