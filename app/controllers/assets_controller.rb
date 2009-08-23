class AssetsController < ApplicationController
  before_filter :require_user, :except => [:index, :show]
  
  make_resourceful do
    actions :all, :except => [:edit, :update]
    belongs_to :site

    publish :xml, :json, :attributes => [:id, :url]
    
    response_for :create do |format|
      format.html { redirect_to current_object }
      format.js
    end
  end

  def search
    @assets = Asset.search "*#{params[:query]}*"
    render :index
  end

  private

  def current_objects
    @current_object ||= current_model.filter_by(params).paginate  :page => params[:page]
  end
end