class Users::PasswordsController < Devise::PasswordsController
  protected

  def after_sending_reset_password_instructions_path_for(resource_name)
    email = params.dig(resource_name, :email)

    flash[:reset_sent] = true
    flash[:reset_email] = email

    new_session_path(resource_name)
  end
end