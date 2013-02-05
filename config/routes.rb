RedmineApp::Application.routes.draw do
  match 'my/default_layout', :controller => 'my', :action => 'default_layout', :via => :post
end
