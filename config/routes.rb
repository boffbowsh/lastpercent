ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|
    admin.resources :workers
    admin.resources :validators
  end

  map.resources :sites, :shallow => true do |site|
    site.resources :assets, :except => [:edit, :update], :collection => { :search => :get } do |asset|
      asset.resources :results, :only => [:index, :show]
    end
    site.resources :results, :only => [:index]
  end

  map.resources :password_resets, :except => [:index, :show, :destroy]
  map.resources :users, :except => [:destroy]

  map.signup    '/signup',  :controller => "users", :action => "new"
  map.login     '/login',   :controller => "user_sessions", :action => "new", :conditions => {:method => :get}
  map.logout    '/logout',  :controller => "user_sessions", :action => "destroy"
  map.resource  :user_session, :as => 'login'

  map.activate  '/activate/:activation_code', :controller => 'users', :action => 'activate'

  map.resources :pages, :only => :show
  map.root      :controller => "pages", :action => 'index'
end
