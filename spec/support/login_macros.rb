module LoginMacros
  def manual_login(user)
    visit new_user_session_path

    fill_in "user[email]", with: user.email
    fill_in "user[password]", with: 'password' # FactoryBotで設定しているパスワード

    click_button "ログイン"
  end
end

RSpec.configure do |config|
  config.include LoginMacros, type: :system
end
