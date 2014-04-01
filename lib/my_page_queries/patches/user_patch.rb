require_dependency 'project'
require_dependency 'principal'
require_dependency 'user'

module MyPageQueries::Patches::UserPatch
  extend ActiveSupport::Concern

  def detect_query(query_id)
    visible_queries.detect { |q| q.id == query_id.to_i }
  end

  def visible_queries
    @visible_queries ||= my_visible_queries.to_a + other_visible_queries.to_a
  end

  def my_visible_queries
    visible_queries_scope.where('queries.user_id = ?', self.id).order('queries.name')
  end

  def other_visible_queries
    visible_queries_scope.where('queries.user_id <> ?', self.id).order('queries.name')
  end

  def queries_from_my_projects
    @queries_from_my_projects ||= other_visible_queries.find_all { |q| q.is_public && q.project && member_of?(q.project) }
  end

  def queries_from_public_projects
    @queries_from_public_projects ||= other_visible_queries.to_a - queries_from_my_projects
  end

  def visible_queries_scope
    kl = defined?(IssueQuery) ? IssueQuery : Query
    kl.visible(self)
  end

  def my_page_text=(val)
    pref[:my_page_text] = val
    pref.save
  end

  def my_page_text
    pref[:my_page_text]
  end
end

unless User.included_modules.include?(MyPageQueries::Patches::UserPatch)
  User.send :include, MyPageQueries::Patches::UserPatch
end
