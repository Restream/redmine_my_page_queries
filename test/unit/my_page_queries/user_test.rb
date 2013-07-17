require File.expand_path('../../../test_helper', __FILE__)

class MyPageQueries::UserTest < ActionView::TestCase
  fixtures :users, :user_preferences, :roles, :projects, :members, :member_roles,
           :issues, :issue_statuses, :trackers, :enumerations, :custom_fields,
           :auth_sources, :queries

  def setup
    @user = User.find(2)
  end

  def test_my_visible_queries
    query_ids = @user.my_visible_queries.map(&:id).sort
    assert_equal [4], query_ids
  end

  def test_other_visible_queries
    query_ids = @user.other_visible_queries.map(&:id).sort
    assert_equal [5, 6, 9], query_ids
  end

  def test_visible_queries
    query_ids = @user.visible_queries.map(&:id).sort
    assert_equal [4, 5, 6, 9], query_ids
  end

  def test_detect_query
    assert_equal 4, @user.detect_query(4).id
    assert_equal 5, @user.detect_query('5').id
    assert_equal 6, @user.detect_query(6).id
    assert_equal 9, @user.detect_query(9).id
    assert_nil @user.detect_query(8)
  end
end
