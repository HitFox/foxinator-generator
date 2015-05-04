class Admin::AdminsController < Admin::BaseController
  
  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  #
  # Concerns
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  include Eventify
  
  #
  # Filter
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  before_action :require_foreign_account, only: :deactivate

  #
  # Plugins
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  #
  # Protected
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  protected

  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  private
  
  def permitted_params
    params.permit(resource_instance_name => [:role_id, :email, :password, :password_confirmation])
  end
  
  def require_foreign_account
    if resource == current_admin
      redirect_to [current_namespace, resource], alert: t('flash.require_foreign_account') 
    end
  end

end
