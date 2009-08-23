class Admin::ValidatorsController < Admin::ApplicationController
  make_resourceful do
    actions :all
  end

  private

  def current_objects
    @current_object ||= current_model.paginate  :page => params[:page]
  end
end