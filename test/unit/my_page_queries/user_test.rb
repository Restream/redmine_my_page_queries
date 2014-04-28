require File.expand_path('../../../test_helper', __FILE__)

class MyPageQueries::UserTest < ActionView::TestCase
  fixtures :users, :user_preferences, :roles, :projects, :members, :member_roles,
           :issues, :issue_statuses, :trackers, :enumerations, :custom_fields,
           :auth_sources, :queries, :enabled_modules

  def setup
    @user = User.find(2)
  end

  def test_my_visible_queries
    query_ids = @user.my_visible_queries.map(&:id).sort
    assert_equal [4, 7, 8], query_ids
  end

  def test_other_visible_queries
    query_ids = @user.other_visible_queries.map(&:id).sort
    assert_equal [1, 5, 6, 9], query_ids
  end

  def test_visible_queries
    query_ids = @user.visible_queries.map(&:id).sort
    assert_equal [1, 4, 5, 6, 7, 8, 9], query_ids
  end

  def test_queries_from_my_projects
    query_ids = @user.queries_from_my_projects.map(&:id).sort
    assert_equal [1], query_ids
  end

  def test_queries_from_public_projects
    query_ids = @user.queries_from_public_projects.map(&:id).sort
    assert_equal [5, 6, 9], query_ids
  end

  def test_detect_query
    assert_equal 4, @user.detect_query(4).id
    assert_equal 5, @user.detect_query('5').id
    assert_equal 6, @user.detect_query(6).id
    assert_equal 9, @user.detect_query(9).id
    assert_nil @user.detect_query(2) # private query user_id: 3
  end

  def test_my_page_custom_text
    test_string = 'test string'
    @user.update_my_page_text_block('text_1', test_string)
    @user.reload
    assert_equal test_string, @user.my_page_text_block('text_1')
  end
end
