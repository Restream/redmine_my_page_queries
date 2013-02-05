require File.expand_path('../../test_helper', __FILE__)
require 'my_controller'

# Re-raise errors caught by the controller.
class MyController; def rescue_action(e) raise e end; end

class MyControllerTest < ActionController::TestCase
  fixtures :users, :user_preferences, :roles, :projects, :members, :member_roles,
  :issues, :issue_statuses, :trackers, :enumerations, :custom_fields, :auth_sources

  def setup
    @controller = MyController.new
    @request    = ActionController::TestRequest.new
    @request.session[:user_id] = 2
    @response   = ActionController::TestResponse.new
    @user = User.find(2)
  end

  def test_index
    get :index
    assert_response :success
  end

  def test_page
    get :page
    assert_response :success
  end

  def test_page_with_timelog_block
    preferences = @user.pref
    preferences[:my_page_layout] = {'top' => ['issues_custom_query_1']}
    preferences.save!

    get :page
    assert_response :success
  end

  def test_page_layout
    get :page_layout
    assert_response :success
  end

  def test_add_block
    post :add_block, :block => 'issues_custom_query_1'
    assert_redirected_to '/my/page_layout'
    assert @user.pref[:my_page_layout]['top'].include?('issues_custom_query_1')
  end

  def test_add_block_to_default
    @user.pref[:my_page_layout] = nil
    post :add_block, :block => 'issues_custom_query_1'
    assert_redirected_to '/my/page_layout'
    @user = User.current
    MyController::DEFAULT_LAYOUT.each do |position, block|
      assert @user.pref[:my_page_layout][position].include?(block.first)
    end
  end

  def test_remove_block
    post :remove_block, :block => 'issues_custom_query_1'
    assert_redirected_to '/my/page_layout'
    assert !@user.pref[:my_page_layout].values.flatten.include?('issues_custom_query_1')
  end

  def test_order_blocks
    xhr :post, :order_blocks, :group => 'left', 'blocks' => ['issues_custom_query_1', 'calendar', 'latestnews']
    assert_response :success
    assert_equal ['issues_custom_query_1', 'calendar', 'latestnews'], @user.pref[:my_page_layout]['left']
  end
end
