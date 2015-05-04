class Admin::CommentsController < Admin::BaseController
  
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

  #
  # Filter
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  #
  # Plugins
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  belongs_to :admin, :profile, :role, :user, polymorphic: true
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def create
    super do |format|
      format.html { redirect_to polymorphic_path([current_namespace, current_parent], anchor: :comments) }
    end
  end
   
   def destroy
     super do |format|
       format.html { redirect_to polymorphic_path([current_namespace, current_parent], anchor: :comments) }
     end
   end
  
  #
  # Protected
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  protected
  
  def build_resource
    super.tap do |comment|
      comment.admin = current_admin
    end
  end

  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  private
  
  def permitted_params
    params.permit(resource_instance_name => [:message])
  end

end
