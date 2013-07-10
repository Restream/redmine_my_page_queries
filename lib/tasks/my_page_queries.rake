namespace :my_page_queries do

  desc 'Upgrade my_page custom_query user settings'
  task :upgrade => [:environment] do
    puts 'Find user that have old settings and convert them.'
    User.active.order(User.fields_for_order_statement).each do |user|
      old = user.pref.others.inspect
      MyPageQueries::UpgradeService.upgrade_settings(user)
      if old != user.pref.others.inspect
        puts "Settings of #{user.name} has converted (old/new): \n\t#{old}\n\t#{user.pref.others.inspect}\n"
      end
    end
  end

end
