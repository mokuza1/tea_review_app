class ApplicationController < ActionController::Base
  before_action :store_location
  before_action :configure_permitted_parameters, if: :devise_controller?
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def after_sign_in_path_for(resource)
    return admin_root_path if resource.admin?

    stored_location_for(resource) || root_path
  end

  private

  def store_location
    if request.get? && !devise_controller?
      store_location_for(:user, request.fullpath)
    end
  end

  protected

  # 新規登録時のストロングパラメータに「nameカラム」の追加
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
  end
end
