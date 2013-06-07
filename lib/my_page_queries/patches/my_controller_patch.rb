module MyPageQueries::Patches::MyControllerPatch
  extend ActiveSupport::Concern

  included do

    before_filter :apply_default_layout, :only => [:add_block, :remove_block],
                  :if => proc { User.current.pref[:my_page_layout].nil? }

    before_filter :my_page_sort_init

    alias_method_chain :page_layout, :queries
    alias_method_chain :add_block, :queries

    helper :sort
    include SortHelper
    helper :queries
    include QueriesHelper

    helper :my_page_queries
    include MyPageQueriesHelper

    helper_method :per_page_option
  end

  def default_layout
    @user = User.current
    # remove block in all groups
    @user.pref[:my_page_layout] = nil
    @user.pref.save
    redirect_to :action => 'page_layout'
  end

  def page_layout_with_queries
    page_layout_without_queries
    @user.visible_queries.each do |q|
      q_name = q.project ? "#{q.name} (#{q.project})" : q.name
      @block_options << [q_name, "query_#{q.id}"]
    end
  end

  def add_block_with_queries
    if (block = detect_query_block_from_params)
      add_block_to_top(User.current, block)
      redirect_to :action => 'page_layout'
    else
      add_block_without_queries
    end
  end

  private

  def apply_default_layout
    user = User.current
    # make a deep copy of default layout
    user.pref[:my_page_layout] = Marshal.load(Marshal.dump(MyController::DEFAULT_LAYOUT))
    user.save
  end

  def my_page_sort_init
    sort_init('none')
    sort_update(['none'])
  end

  def add_block_to_top(user, block)
    layout = user.pref[:my_page_layout] || {}
    # remove if already present in a group
    %w(top left right).each {|f| (layout[f] ||= []).delete block }
    # add it on top
    layout['top'].unshift block
    user.pref[:my_page_layout] = layout
    user.pref.save
  end

  def detect_query_block_from_params
    block = params[:block].to_s.underscore
    block if extract_query_id_from_block(block)
  end
end

unless MyController.included_modules.include?(MyPageQueries::Patches::MyControllerPatch)
  MyController.send :include, MyPageQueries::Patches::MyControllerPatch
end
