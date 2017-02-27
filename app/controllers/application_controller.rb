class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, :only => [:new, :create]
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters 
     devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

end
