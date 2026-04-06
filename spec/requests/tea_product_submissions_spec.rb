require 'rails_helper'

RSpec.describe "TeaProductSubmissions", type: :request do
  let(:user) { create(:user) }
  let(:brand) { create(:brand, status: :published) }
  let(:flavor) { create(:flavor) }

  before do
    sign_in user
  end

  describe "POST /tea_product_submissions" do
    let(:valid_params) do
      {
        tea_product_submission: {
          name: "究極のダージリン",
          brand_id: brand.id,
          tea_type: "black",
          caffeine_level: "caffeinated",
          description: "香りが素晴らしいです。",
          flavor_ids: [ flavor.id ]
        }
      }
    end

    it "新しい紅茶申請が作成され、編集画面へリダイレクトされること" do
      expect {
        post tea_product_submissions_path, params: valid_params
      }.to change(TeaProductSubmission, :count).by(1)

      expect(response).to redirect_to(edit_tea_product_submission_path(TeaProductSubmission.last))

      follow_redirect!
      expect(response.body).to include "下書きを作成しました"
    end

    it "名前が空であっても、下書き(draft)としてなら保存に成功すること" do
      invalid_params = { tea_product_submission: { name: "", brand_id: brand.id } }

      expect {
        post tea_product_submissions_path, params: invalid_params
      }.to change(TeaProductSubmission, :count).by(1) # モデルの仕様通り保存される

      expect(TeaProductSubmission.last.status).to eq "draft"
    end
  end

  describe "PATCH /tea_product_submissions/:id/submit" do
    let!(:draft_submission) { create(:tea_product_submission, user: user, status: :draft, name: "") }

    it "名前が空のまま申請しようとすると、エラーが発生しステータスが更新されないこと" do
      patch submit_tea_product_submission_path(draft_submission)

      draft_submission.reload
      expect(draft_submission.status).to eq "draft"

      expect(response).to have_http_status(:unprocessable_entity).or have_http_status(:ok)
      expect(response.body).to include "商品名を入力してください"
    end
  end

  describe "Authentication" do
    it "未ログインなら投稿ページにアクセスできないこと" do
      sign_out user
      get new_tea_product_submission_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
