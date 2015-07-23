class ApplicationController < ActionController::Base

  rescue_from ActionController::RoutingError, with: :set_rescue_locale

  #
  # Concerns
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  include Routify, Sortify, Localizify, Redirectify
  
  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #

  protect_from_forgery with: :exception
  
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

  def set_rescue_locale(exception)
    if exception.message == 'Site Not Found' && request.path == '/'
      redirect_to "/#{parsed_locale}"
    else
      raise(exception)
    end
  end
end
