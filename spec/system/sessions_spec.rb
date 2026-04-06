require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  let(:user) { create(:user, email: "test@example.com", password: "password") }

  it "トップページが正しく表示されること" do
    visit root_path
    # "検索" を、実際に画面にある文言に変更
    expect(page).to have_content "みんなの紅茶図鑑"
    expect(page).to have_content "フレーバーから探す"
  end

  it "ログインしてトップページに遷移できること" do
    manual_login(user)
    expect(page).to have_content "ログインしました"
    expect(current_path).to eq root_path
  end
end
