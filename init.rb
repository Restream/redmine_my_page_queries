require 'redmine'

ActionDispatch::Callbacks.to_prepare do
  require 'my_page_queries'
end

Redmine::Plugin.register :redmine_my_page_queries do
  name 'MyPage custom queries'
  description 'Adds custom queries onto My Page screen'
  version '2.1.2'
  author 'Undev'
  author_url 'https://github.com/Undev'
  url 'https://github.com/Undev/redmine_my_page_queries'

  requires_redmine '2.1.0'
end
