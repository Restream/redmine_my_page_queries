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
      query_presenter = QueryPresenter.new(query)
      redm_version = Redmine::VERSION::MINOR < 2 ? '_2_1_0' : ''
      render "my/query_block#{redm_version}",
             :user => user,
             :query => query_presenter
    else
      render "my/blocks/#{block}", :user => user
    end
  end
end
