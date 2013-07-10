namespace :my_page_queries do

  desc 'Upgrade my_page custom_query user settings'
  task :upgrade => [:environment] do
    puts 'Find user that have old settings and convert them.'
    User.active.order(User.fields_for_order_statement).each do |user|
      my_page = user.pref[:others] && user.pref[:others][:my_page_layout]
      if my_page
        old_keys = my_page.values.flatten.find_all { |k| k =~ /\Aissues_custom_query_\d\z/ }
        if old_keys.any?
          puts "#{user.name} -> [#{old_keys.join(', ')}]"
        end
      end
    end
  end

end
