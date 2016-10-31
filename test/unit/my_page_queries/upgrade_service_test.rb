require File.expand_path('../../../test_helper', __FILE__)

class MyPageQueries::UpgradeServiceTest < ActionView::TestCase
  fixtures :users, :user_preferences, :roles, :projects, :members, :member_roles,
           :issues, :issue_statuses, :trackers, :enumerations, :custom_fields,
           :auth_sources, :queries

  def setup
    @user = User.find(2)
    @user.pref.save!
  end

  def test_upgrade_old_settings
    old_settings = {
      my_page_layout: {
        'left'  => ['issuesassignedtome', 'issues_custom_query_1'],
        'right' => ['issues_custom_query_2'],
        'top'   => ['issues_custom_query_3', 'issuesreportedbyme']
      },
      custom_query1:  { id: 21, limit: 30 },
      custom_query2:  { id: 22, limit: 20 },
      custom_query3:  { id: 23, limit: 10 },
      query_23:       { some: 'option' }
    }
    new_settings = {
      my_page_layout: {
        'left'  => ['issuesassignedtome', 'query_21'],
        'right' => ['query_22'],
        'top'   => ['query_23', 'issuesreportedbyme']
      },
      query_21:       { limit: 30 },
      query_22:       { limit: 20 },
      query_23:       { some: 'option', limit: 10 }
    }
    @user.pref.others.merge! old_settings
    @user.pref.save!
    MyPageQueries::UpgradeService.upgrade_settings(@user)
    user = User.find(2)

    assert_equal new_settings[:my_page_layout], user.pref.others[:my_page_layout]
    assert_equal new_settings[:query_21], user.pref.others[:query_21]
    assert_equal new_settings[:query_22], user.pref.others[:query_22]
    assert_equal new_settings[:query_23], user.pref.others[:query_23]
    refute user.pref.others[:custom_query1]
    refute user.pref.others[:custom_query2]
    refute user.pref.others[:custom_query3]
  end
end
