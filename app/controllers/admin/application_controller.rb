class Admin::ApplicationController < ApplicationController
  before_filter :require_user
  before_filter :require_admin

  private

  def namespaces
    [:admin]
  end
end
