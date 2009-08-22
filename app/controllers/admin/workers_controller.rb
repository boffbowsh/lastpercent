class Admin::WorkersController < Admin::ApplicationController
  make_resourceful do
    actions :all
  end

  private

  def namespaces
    [:admin]
  end
end