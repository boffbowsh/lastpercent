ActionController::Routing::Routes.draw do |map|
  map.resources :password_resets
  map.resources :users
  map.root      :controller => "users"
  
  map.login     '/login',                     :controller => "user_sessions", :action => "new", :conditions => {:method => :get}
  map.logout    '/logout',                    :controller => "user_sessions", :action => "destroy"
  map.resource  :user_session, :as => 'login'

  map.activate  '/activate/:activation_code', :controller => 'users',         :action => 'activate'
end
