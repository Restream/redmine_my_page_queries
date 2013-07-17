class QueryPresenter < SimpleDelegator

  DEFAULT_LIMIT = 10

  def initialize(obj, view_context)
    super(obj)
    @view_context = view_context
  end

  def title
    "#{name} (#{issue_count})"
  end

  def link(title)
    url_opts = { :controller => 'issues',
                 :action => 'index',
                 :query_id => id }
    url_opts[:project_id] = project.id unless project.nil?
    @view_context.link_to title, url_opts
  end

  def issues(options = {})
    options.merge!(
      :include => [:assigned_to, :tracker, :priority, :category, :fixed_version],
      :limit => limit
    )
    super(options)
  end

  def limit
    optn = pref_options[:limit]
    optn && optn.to_i || DEFAULT_LIMIT
  end

  def available_limits
    (Setting.per_page_options_array + [1,3,5,10]).sort.uniq
  end

  private

  def pref_options
    User.current.pref.others[pref_key] || {}
  end

  def pref_key
    "query_#{id}".to_sym
  end

end
