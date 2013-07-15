class QueryPresenter < SimpleDelegator

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

  def issues
    super(
        :include => [:assigned_to, :tracker, :priority, :category, :fixed_version],
        :limit => per_page_option)
  end

  def per_page_option

  end

end
