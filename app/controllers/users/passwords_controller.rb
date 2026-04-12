class Users::PasswordsController < Devise::PasswordsController
  def edit
    token = params[:reset_password_token]

    if token.blank?
      redirect_to new_password_path(resource_name), alert: "無効なリンクです"
      return
    end

    user = resource_class.with_reset_password_token(token)

    if user.nil?
      redirect_to new_password_path(resource_name, expired: true)
    else
      super
    end
  end

  protected

  def after_sending_reset_password_instructions_path_for(resource_name)
    email = params.dig(resource_name, :email)

    flash.delete(:notice)

    flash[:reset_sent] = true
    flash[:reset_email] = email

    new_session_path(resource_name)
  end
end
