module Permitify
  extend ActiveSupport::Concern
  
  included do
    before_action :require_permission!
  end
  
  def require_permission!
    return false unless current_admin
    
    unless current_admin.permitted_to?(params)
      respond_to do |format|
        format.html { redirect_to polymorphic_path([:admin, :root]), alert: t('flash.unpermitted') }
        format.xml { head :ok }
        format.js do
          flash.now[:alert] = t('flash.unpermitted')
          render js: "window.location = '#{polymorphic_path([:admin, :root])}'"
        end
      end
      return false
    end
  end
  
end