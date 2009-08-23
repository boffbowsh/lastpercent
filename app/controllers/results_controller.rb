class ResultsController < ApplicationController
  before_filter :require_user
  before_filter :require_owner

  make_resourceful do
    actions :index, :show
    belongs_to :site, :asset

    publish :xml, :json, :attributes => [:id, :message_id, :severity]
  end

  private

  def current_objects
    @current_object ||= current_model.filter_by(params).paginate  :page => params[:page]
  end

  def require_owner
    if parent_object
      access_denied unless current_user.admin? ||  current_user == parent_object.user
    else
      access_denied unless current_user.admin? ||  current_user == current_object.user
    end
  end
end