class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :authenticate_user!, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:preferred_units])
    devise_parameter_sanitizer.permit(:account_update, keys: [:preferred_units])
  end

  def user_not_authorized
    redirect_to(request.referer || root_path, alert: "You are not authorized to perform this action.")
  end
end
