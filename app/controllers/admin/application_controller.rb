class Admin::ApplicationController < ApplicationController
  before_filter :require_user
end
