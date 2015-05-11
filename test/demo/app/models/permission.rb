class Permission < ActiveRecord::Base

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  #
  # Constants
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  #
  # Attribute Settings
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

  #
  # Concerns
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  #
  # Index
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  #
  # State Machine
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  #
  # Scopes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  #
  # Associations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  has_and_belongs_to_many :admins, -> { uniq }
  has_and_belongs_to_many :roles, -> { uniq }
  
  #
  # Nested Attributes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  #
  # Validations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  validates :controller, :action, presence: true

  validates :action, uniqueness: { scope: :controller }

  #
  # Callbacks
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  #
  # Delegates
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  #
  # Instance Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def name
    [controller, action].join('/')
  end

  #
  # Class Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def self.sync_and_permit_admins!    
    synchronize_routes and permit_super_admin!
  end
  
  def self.permit_super_admin!
    role = Role.find_by_identifier(:super_admin)
    role.update_attributes(permission_ids: Permission.pluck(:id)) if role
  end
  
  def self.synchronize_routes(options = {})    
    Rails.logger.info "**[Permission Synchronizer] Starting permission sync for #{wanted_routes.size} routes." 
    
    Rails.logger.silence do
      wanted_routes(options).map do |route|
        create(route.requirements.slice(:controller, :action))
      end
    end
    
    Rails.logger.info "**[Permission Synchronizer] Successfully synchronized #{wanted_routes.size} routes." 
  end
  
  class << self
    alias :sync :synchronize_routes
  end

  def self.route_wanted?(route, options = {})
    default_options = {
      namespaces: Settings.permissions.namespaces,
      excepted_controllers: Settings.permissions.permitted.controllers
    }
    configuration = default_options.merge(options)
    
    route.requirements.present? &&
    route.requirements.has_key?(:controller) &&
    configuration[:namespaces].any? { |namespace| route.requirements[:controller].include?("#{namespace.to_s}/") } &&
    (configuration[:excepted_controllers].blank? || !configuration[:excepted_controllers].include?(route.requirements[:controller]))
  end

  def self.wanted_routes(options = {})
    wanted_routes = []
    Rails.application.routes.routes.each do |route|
      wanted_routes << route if route_wanted?(route, options)
    end
    wanted_routes.compact
  end

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

end
