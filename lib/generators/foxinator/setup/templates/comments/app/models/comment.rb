class Comment < ActiveRecord::Base

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
  
  EMAIL_REGEXP = /([^@\s]{1,64})(@)((?:[-a-z0-9]+\.)+[a-z]{2,})/

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
  
  belongs_to :admin
  belongs_to :commentable, polymorphic: true
  
  has_and_belongs_to_many :admins, -> { uniq }
  
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
  
  validates :admin_id, :commentable_id, :message, presence: true

  #
  # Callbacks
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  before_create :set_linked_message
  
  after_create :set_admins!, :send_admin_mention
  
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
  
  def mentioned_emails
    @mentioned_emails ||= message.scan(EMAIL_REGEXP).map(&:join) 
  end
  
  def mentioned_admins
    return [] unless mentioned_emails.any?

    @mentioned_admins ||= Admin.where(email: mentioned_emails)
  end
    
  def linked_message(admins = mentioned_admins)
    return message unless admins.any?

    linked_message = message.dup
    
    admins.each do |admin| 
      linked_message.gsub!(admin.email, ActionController::Base.helpers.link_to(admin.email, Rails.application.routes.url_helpers.admin_admin_url(admin, host: Settings.mailer.default_url_options.host)))
    end

    linked_message
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
  
  def set_linked_message
    self.message = linked_message
  end
  
  def set_admins!
    self.admins = mentioned_admins
  end
  
  def send_admin_mention
    CommentMailer.admin_mention(self).deliver if admins.any?
  end

end
