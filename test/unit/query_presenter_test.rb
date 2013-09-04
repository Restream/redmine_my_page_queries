require File.expand_path('../../test_helper', __FILE__)

class QueryPresenterTest < ActionView::TestCase
  fixtures :users, :user_preferences, :roles, :projects, :members, :member_roles,
           :issues, :issue_statuses, :trackers, :enumerations, :custom_fields,
           :auth_sources, :queries, :enabled_modules

  include ActionView::TestCase::Behavior

  def setup
    @user = User.find(2)
    User.current = @user
    @query = Query.find(5)
    @query_presenter = QueryPresenter.new(@query, view)
  end

  def test_query_methods_available
    assert_equal @query.issue_count, @query_presenter.issue_count
  end

  def test_title
    title = "#{@query.name} (#{@query.issue_count})"
    assert_equal title, @query_presenter.title
  end

  def test_link
    assert_equal '<a href="/issues?query_id=5">title</a>',
                 @query_presenter.link('title')
  end

  def test_issues
    assert_not_empty @query_presenter.issues
  end

  def test_default_limit
    assert_equal QueryPresenter::DEFAULT_LIMIT, @query_presenter.limit
  end

  def test_limit
    @user.pref[:query_5] = { :limit => 20 }
    @user.pref.save!
    @user.pref.reload
    assert_equal 20, @query_presenter.limit
  end

  def test_available_limits
    limits = [1, 3, 5, 10, 25, 50, 100]
    assert_equal limits, @query_presenter.send(:available_limits)
  end
end
