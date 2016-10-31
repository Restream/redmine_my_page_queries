require 'redmine'

ActionDispatch::Callbacks.to_prepare do
  require 'my_page_queries'
end

Redmine::Plugin.register :redmine_my_page_queries do
  name 'MyPage custom queries'
  description 'Adds custom queries onto My Page screen'
  version '2.1.7'
  author 'Restream'
  author_url 'https://github.com/Restream'
  url 'https://github.com/Restream/redmine_my_page_queries'
end
