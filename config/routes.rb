RedmineApp::Application.routes.draw do
  post 'my/default_layout', :to => 'my#default_layout'
  put 'my/update_query_block/:query_id',
      :to => 'my#update_query_block',
      :as => :update_query_block
  put 'my/text', :to => 'my#update_text', :as => :update_my_page_text
end
