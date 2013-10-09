require File.expand_path('../../../test_helper', __FILE__)

#require 'projects_controller'

class MyPageQueries::ProjectsControllerTest < ActionController::TestCase
  fixtures :projects, :versions, :users, :roles, :members, :member_roles, :issues, :journals, :journal_details,
           :trackers, :projects_trackers, :issue_statuses, :enabled_modules, :enumerations, :boards, :messages,
           :attachments, :custom_fields, :custom_values, :time_entries

  def setup
    @controller = ProjectsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session[:user_id] = nil
    Setting.default_language = 'en'
  end

  def test_create_project
    @request.session[:user_id] = 1
    post :create,
         :project => {
             :name => "blog",
             :description => "weblog",
             :homepage => 'http://weblog',
             :identifier => "blog",
             :is_public => 1,
             :custom_field_values => { '3' => 'Beta' },
             :tracker_ids => ['1', '3'],
             # an issue custom field that is not for all project
             :issue_custom_field_ids => ['9'],
             :enabled_module_names => ['issue_tracking', 'news', 'repository']
         }
    assert_redirected_to '/projects/blog/settings'

    project = Project.find_by_name('blog')
    assert_kind_of Project, project
    assert project.active?
    assert_equal 'weblog', project.description
    assert_equal 'http://weblog', project.homepage
    assert_equal true, project.is_public?
    assert_nil project.parent
    assert_equal 'Beta', project.custom_value_for(3).value
    assert_equal [1, 3], project.trackers.map(&:id).sort
    assert_equal ['issue_tracking', 'news', 'repository'], project.enabled_module_names.sort
    assert project.issue_custom_fields.include?(IssueCustomField.find(9))
  end

end
