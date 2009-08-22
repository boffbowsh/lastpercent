ActionController::Routing::Routes.draw do |map|
  map.resources :password_resets, :except => [:index, :show, :destroy]
  map.resources :users, :except => [:destroy]

  map.login     '/login',   :controller => "user_sessions", :action => "new", :conditions => {:method => :get}
  map.logout    '/logout',  :controller => "user_sessions", :action => "destroy"
  map.resource  :user_session, :as => 'login'

  map.activate  '/activate/:activation_code', :controller => 'users', :action => 'activate'

  map.resources :pages, :only => :show
  map.root      :controller => "users"
end
