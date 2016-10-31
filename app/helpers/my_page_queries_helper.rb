module MyPageQueriesHelper
  def block_exists?(user, block)
    MyController::BLOCKS.keys.include?(block) ||
      query_from_block(user, block) ||
      text_block?(block)
  end

  def extract_query_id_from_block(block)
    $1.to_i if block =~ /\Aquery_(\d+)\z/
  end

  def query_from_block(user, block)
    query_id = extract_query_id_from_block(block)
    user.detect_query(query_id)
  end

  def text_block?(block)
    block =~ /\Atext_(\d+)\z/
  end

  def render_block(user, block_name)
    if (query = query_from_block(user, block_name))
      query_presenter = QueryPresenter.new(query, self)
      render query_block_partial_name,
             user:  user,
             query: query_presenter
    elsif text_block?(block_name)
      render 'my/text_block',
             user:       user,
             block_name: block_name,
             text:       user.my_page_text_block(block_name)
    else
      render "my/blocks/#{block_name}", user: user
    end
  end

  def query_block_partial_name
    'my/query_block'
  end

  def link_to_query(query, html_options = {})
    url_params              = { controller: 'issues', action: 'index', query_id: query.id }
    url_params[:project_id] = query.project.identifier if query.project
    link_to query.name, url_params, html_options
  end

  def block_options_for_select(user = User.current)
    my_page_blocks = @block_options + [[l(:field_text), MyPageQueries::TEXT_BLOCK]]
    content_tag('option') +
      grouped_options_for_select(l(:label_my_page_block) => my_page_blocks) +
      grouped_options_for_select(my_queries(user)) +
      grouped_options_for_select(queries_from_my_projects(user)) +
      grouped_options_for_select(queries_from_public_projects(user))
  end

  def my_queries(user)
    queries = reject_used_queries(user.my_visible_queries)
    queries.empty? ? {} : { l(:label_my_queries) => grouped_queries_for_select(queries) }
  end

  def queries_from_my_projects(user)
    queries = reject_used_queries(user.queries_from_my_projects)
    queries.empty? ? {} : { l(:label_queries_from_my_projects) => grouped_queries_for_select(queries) }
  end

  def queries_from_public_projects(user)
    queries = reject_used_queries(user.queries_from_public_projects)
    queries.empty? ? {} : { l(:label_queries_from_public_projects) => grouped_queries_for_select(queries) }
  end

  def grouped_queries_for_select(queries)
    result = []

    by_project = queries.group_by { |q| q.project }
    global     = by_project.delete(nil) || []

    result     += global.map { |q| [q.name, query_string_id(q)] } if global.any?

    by_project.each do |project, queries|
      result += queries.map { |q| ["#{project.name} - #{q.name}", query_string_id(q)] }
    end

    result
  end

  def reject_used_queries(queries)
    queries.reject { |q| @blocks.values.flatten.include? query_string_id(q) }
  end

  def query_string_id(query)
    "query_#{query.id}"
  end
end
