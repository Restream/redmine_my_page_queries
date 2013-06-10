module MyPageQueriesHelper
  def block_exists?(user, block)
    MyController::BLOCKS.keys.include?(block) || query_from_block(user, block)
  end

  def extract_query_id_from_block(block)
    $1.to_i if block =~ /\Aquery_(\d+)\z/
  end

  def query_from_block(user, block)
    query_id = extract_query_id_from_block(block)
    user.detect_query(query_id)
  end

  def render_block(user, block)
    if (query = query_from_block(user, block))
      render 'my/query_block', :user => user, :query => query
    else
      render "my/blocks/#{block}", :user => user
    end
  end

  def query_title(query)
    "#{query.name} (#{query.issue_count})"
  end

  def query_link(query)
    url_opts = { :controller => 'issues',
                 :action => 'index',
                 :query_id => query.id }
    url_opts[:project_id] = query.project.id unless query.project.nil?
    link_to query_title(query), url_opts
  end
end
