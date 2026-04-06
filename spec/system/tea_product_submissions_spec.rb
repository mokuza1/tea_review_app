require 'rails_helper'

RSpec.describe "TeaProductSubmissions", type: :system do
  let(:user) { create(:user) }
  # 一覧表示用にデータをいくつか作成しておく
  let!(:tea_product) do
    create(:tea_product, 
      user: user, 
      name: "テストの紅茶", 
      description: "これはテスト用の説明文です"
    )
  end

  before do
    sign_in user
  end

  it "投稿一覧から投稿詳細を確認できること" do
    # 1. 一覧ページへアクセス
    visit tea_products_path
    expect(page).to have_content "テストの紅茶"

    # 2. 詳細リンク（または名前）をクリック
    click_on "テストの紅茶"

    # 3. 詳細ページの内容を確認
    expect(page).to have_content "テストの紅茶"
    expect(page).to have_content "これはテスト用の説明文です"
    expect(current_path).to eq tea_product_path(tea_product)
  end
end
