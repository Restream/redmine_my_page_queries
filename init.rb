require 'redmine'

Fixnum.class_eval do
  def to_custom_query_limit
    return 1 if self <= 0
    self
  end
end

String.class_eval do
  def to_custom_query_limit
    to_i.to_custom_query_limit
  end
end

Rails.application.paths["app/overrides"] ||= []
Rails.application.paths["app/overrides"] << File.expand_path("../app/overrides", __FILE__)

require 'my_page_queries/patches/my_controller_patch'

Redmine::Plugin.register :redmine_my_page_queries do
  name 'MyPage custom queries'
  description 'Adds custom queries onto My Page screen'
  version '0.0.3'
  author 'Undev'
  author_url 'https://github.com/Undev'
  url 'https://github.com/Undev/redmine_my_page_queries'
end
