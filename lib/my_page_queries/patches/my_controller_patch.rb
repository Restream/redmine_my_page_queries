module MyPageQueries::Patches::MyControllerPatch
  extend ActiveSupport::Concern

  included do

    before_filter :apply_default_layout, :only => [:add_block, :remove_block],
                  :if => proc { User.current.pref[:my_page_layout].nil? }

  end

  ##
  # Restore to default layout
  #
  def default_layout
    @user = User.current
    # remove block in all groups
    @user.pref[:my_page_layout] = nil
    @user.pref.save
    redirect_to :action => 'page_layout'
  end

  private

  def apply_default_layout
    user = User.current
    # make a deep copy of default layout
    user.pref[:my_page_layout] = Marshal.load(Marshal.dump(MyController::DEFAULT_LAYOUT))
    user.save
  end
end

unless MyController.included_modules.include?(MyPageQueries::Patches::MyControllerPatch)
  MyController.send :include, MyPageQueries::Patches::MyControllerPatch
end
