RedmineApp::Application.routes.draw do
  post 'my/default_layout', :to => 'my#default_layout'
  put 'my/update_query_block/:query_id',
      :to => 'my#update_query_block',
      :as => :update_query_block
  put 'my/update_text_block/:block_name',
      :to => 'my#update_text_block',
      :as => :update_text_block
end
