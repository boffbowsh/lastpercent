class Admin::WorkersController < Admin::ApplicationController
  make_resourceful do
    actions :all
  end
end