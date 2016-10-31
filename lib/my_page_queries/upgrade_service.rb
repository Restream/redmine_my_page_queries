class MyPageQueries::UpgradeService
  class << self
    def upgrade_settings(user)
      service = self.new(user)
      service.send :upgrade_settings
    end
  end

  private

  attr_reader :user

  OLD_QUERY_RE = /\Acustom_query(\d)\z/
  OLD_BLOCK_RE = /\Aissues_custom_query_(\d)\z/

  def initialize(_user)
    @user = _user
  end

  def upgrade_settings
    return unless my_page_pref
    old_settings = extract_old_settings
    replace_old_query_settings(old_settings)
    convert_blocks(old_settings)
    user.pref.save!
  end

  def my_page_pref
    user.pref.others[:my_page_layout]
  end

  def extract_old_settings
    result = {}
    user.pref.others.dup.each do |key, val|
      if key =~ OLD_QUERY_RE
        result[$1] = val
        user.pref.others.delete(key)
      end
    end
    result
  end

  def replace_old_query_settings(settings)
    settings.each do |_, options|
      new_query_key                           = "query_#{options[:id]}".to_sym
      user.pref.others[new_query_key]         ||= {}
      user.pref.others[new_query_key][:limit] = options[:limit]
    end
  end

  def convert_blocks(mapping)
    user.pref.others[:my_page_layout].each do |zone, blocks|
      blocks.map! do |block|
        if block =~ OLD_BLOCK_RE
          query_id = mapping[$1] && mapping[$1][:id]
          "query_#{query_id}" if query_id
        else
          block
        end
      end
      blocks.compact!
    end
  end


end
