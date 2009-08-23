class AssetsController < ApplicationController
  before_filter :require_user
  before_filter :require_owner
  
  make_resourceful do
    actions :all, :except => [:edit, :update]
    collection_actions :search
    belongs_to :site

    publish :xml, :json, :attributes => [:id, :url]
    
    response_for :create do |format|
      format.html { redirect_to current_object }
      format.js
    end
  end

  def search
    @assets = Asset.search "*#{params[:query]}*"

    respond_to do |format|
      format.html { render :index }
      format.json { render :json => @assets }
      format.xml { render :xml => @assets }
      format.js
    end
  end

  private

  def current_objects
    @current_object ||= current_model.has_content_type.filter_by(params).paginate  :page => params[:page], :order => 'assets.external ASC, results.severity DESC', :include => :results
  end

  def require_owner
    if parent_object
      access_denied unless current_user.admin? || current_user == parent_object.user
    else
      access_denied unless current_user.admin? || current_user == current_object.user
    end
  end
end