require 'redmine'

class String
  def to_custom_query_limit
    r = to_i
    return 1  if r <= 0
    r
  end
end

Redmine::Plugin.register :redmine_my_page_queries do
  name 'MyPage custom queries'
  author 'Milan Stastny of ALVILA SYSTEMS'
  description 'Adds custom queries onto My Page screen'
  version '0.0.1'
  author_url 'http://www.alvila.com'
end

