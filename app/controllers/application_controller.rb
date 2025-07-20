class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  protected

  # Custom redirect path after sign in
  def after_sign_in_path_for(resource)
    return admin_dashboard_path if resource.is_a?(Admin)

    super
  end

  # Custom redirect path after sign out
  def after_sign_out_path_for(resource_or_scope)
    return new_admin_session_path if resource_or_scope == :admin

    super
  end
end
