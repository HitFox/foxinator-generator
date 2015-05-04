class Admin::BaseController < ApplicationController
  
  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  layout 'comfy/admin/cms'
  
  helper :sort
  
  #
  # Concerns
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  include Permitify

  #
  # Filter
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  before_action :authenticate_admin!

  #
  # Plugins
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  inherit_resources
  
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
  
  def collection
    query = apply_sorting(end_of_association_chain)
    query = query.includes(:translations) if resource_class.respond_to?(:translations_table_name)
    get_collection_ivar || set_collection_ivar(query)
  end

  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  private

end
