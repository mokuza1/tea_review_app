require 'rails_helper'

RSpec.describe "紅茶の投稿フロー", type: :system do 
  let(:user) { create(:user) }

  it "ログインできること" do
    login_as(user)
    # ログイン後のリダイレクト先にあるはずの文言をチェック
    expect(page).to have_content 'ログインしました' 
  end
end
