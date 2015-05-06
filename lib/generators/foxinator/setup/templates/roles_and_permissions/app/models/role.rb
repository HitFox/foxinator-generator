class Role < ActiveRecord::Base

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
  
  attr_accessor :previous_permissions
  
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
  
  has_many :admins, dependent: :nullify
  
  has_and_belongs_to_many :permissions, -> { uniq }
  
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
  
  validates :name, :identifier, presence: true

  #
  # Callbacks
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  before_validation :set_identifier
  
  after_save :set_admin_permissions!
  
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

  #
  # Class Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def self.exists?(identifier)
    return false unless identifier
    
    where(identifier: identifier).exists?
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
  
  def set_identifier
    self.identifier = name.parameterize('_') if name_changed?
  end
  
  def set_admin_permissions!
    self.previous_permissions ||= []
    
    admins.each do |admin|
      custom_permissions = admin.permissions - previous_permissions
      admin.permissions = permissions + custom_permissions
    end
  end

end
