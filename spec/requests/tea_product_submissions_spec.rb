require 'rails_helper'

RSpec.describe "TeaProductSubmissions", type: :request do
  let(:user) { create(:user) }
  let(:brand) { create(:brand, status: :published) }
  let(:flavor) { create(:flavor) }

  before do
    # Deviseのヘルパーを使ってログイン状態にする（ブラウザ操作不要！）
    sign_in user
  end

  describe "POST /tea_product_submissions" do
    let(:valid_params) do
      {
        tea_product_submission: {
          name: "究極のダージリン",
          brand_id: brand.id,
          brand_name: brand.name_ja,
          tea_type: "black",
          caffeine_level: "caffeinated",
          description: "香りが素晴らしいです。",
          flavor_ids: [flavor.id]
        }
      }
    end

    it "新しい紅茶申請が作成され、リダイレクトされること" do
      expect {
        post tea_product_submissions_path, params: valid_params
      }.to change(TeaProductSubmission, :count).by(1)

      # 投稿後のリダイレクト先を確認（例: 詳細画面やサンクスページ）
      expect(response).to redirect_to(edit_tea_product_submission_path(TeaProductSubmission.last))
      
      # フラッシュメッセージの確認
      follow_redirect!
      expect(response.body).to include "下書きを作成しました"
    end
  end
end