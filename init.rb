require 'redmine'

class Integer
  def to_custom_query_limit
    return 1  if self <= 0
    self
  end
end

class String
  def to_custom_query_limit
    to_i.to_custom_query_limit
  end
end

Redmine::Plugin.register :redmine_my_page_queries do
  name 'MyPage custom queries'
  author 'Milan Stastny of ALVILA SYSTEMS'
  description 'Adds custom queries onto My Page screen'
  version '0.0.1'
  author_url 'http://www.alvila.com'
end

