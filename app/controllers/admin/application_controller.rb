class Admin::ApplicationController < ApplicationController
  before_filter :require_user

  private

  def namespaces
    [:admin]
  end
end
