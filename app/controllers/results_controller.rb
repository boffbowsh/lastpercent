class ResultsController < ApplicationController
  make_resourceful do
    actions :index, :show
    belongs_to :site, :asset

    publish :xml, :json, :attributes => [:id, :message_id, :severity]
  end

  private

  def current_objects
    @current_object ||= current_model.paginate  :page => params[:page]
  end
end