class Admin < ActiveRecord::Base

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
  
  alias_attribute :name, :email
  
  #
  # Plugins
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  # 
  
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  #
  # Concerns
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  include Commentable
  
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
  
  state_machine initial: :active do
    state :active
    state :inactive
    
    event :activate do
      transition inactive: :active
    end
    
    event :deactivate do
      transition active: :inactive
    end
  end

  #
  # Scopes
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  scope :by_role_id, -> (role_id) { where(role_id: role_id) }

  #
  # Associations
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  belongs_to :role
  
  has_and_belongs_to_many :permissions, uniq: true
  
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
  
  validates :role_id, presence: true

  #
  # Callbacks
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  before_save :set_role_permissions
  
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
  
  def password_required?
    new_record? || password.present? || password_confirmation.present?
  end
  
  def permitted_to?(*args)
    return false if inactive? || args.blank?
    
    options = args.extract_options!.to_hash.symbolize_keys
    path = args.first if args.first.kind_of?(String)

    if path.present?
      options = begin
        Rails.application.routes.recognize_path(path, options)
      rescue
        {}
      end
    end

    if options[:controller] && options[:action]
      namespace = options[:controller].split('/').first if options[:controller].split('/').size > 1
      
      if namespace && Settings.permissions.namespaces.include?(namespace.to_sym)
        Settings.permissions.permitted.controllers.include?(options[:controller]) || 
          Rails.logger.silence { permissions.where(options.slice(:controller, :action)).exists? }
      else
        true
      end
    else
      true
    end
  end
  
  def method_missing(method_name, *args, &block)
    stringified_method_name = method_name.to_s
    comparable_method_name = stringified_method_name.last == '?' ? stringified_method_name.gsub!('?', '') : nil
    comparable_method_name && comparable_method_name == role.try(:identifier) ? true : super
  end

  #
  # Class Methods
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
  
  def set_role_permissions
    self.permissions = role.permissions if role_id_changed? && role
  end

end
