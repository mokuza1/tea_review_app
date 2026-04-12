require 'rails_helper'

RSpec.describe TeaProductSubmission, type: :model do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  describe "バリデーション" do
    context "ステータスが draft（下書き）の場合" do
      it "名前やブランドが空でも有効であること" do
        submission = build(:tea_product_submission, status: :draft, name: nil, brand: nil)
        expect(submission).to be_valid
      end
    end

    context "ステータスが pending（申請中）の場合" do
      let(:submission) { build(:tea_product_submission, status: :pending) }

      it "名前がなければ無効であること" do
        submission.name = nil
        expect(submission).to be_invalid
        expect(submission.errors[:name].join).to include("商品名を入力してください")
      end

      it "フレーバーが1つも選択されていないと無効であること" do
        submission.flavors = []
        expect(submission).to be_invalid
        expect(submission.errors[:base].join).to include("フレーバーを1つ以上選択してください")
      end

      it "購入場所が1つもないと無効であること" do
        submission.tea_product_submission_purchase_locations = []
        expect(submission).to be_invalid
        expect(submission.errors[:base].join).to include("購入場所を1件登録してください")
      end
    end
  end

  describe "#approve!" do
    let(:submission) { create(:tea_product_submission, :to_be_pending) }

    it "TeaProductが作成され、ステータスがapprovedになること" do
      expect {
        submission.approve!(admin)
      }.to change(TeaProduct, :count).by(1)

      expect(submission.status).to eq "approved"
      expect(submission.tea_product).to be_present
      expect(submission.tea_product.name).to eq submission.name
    end

    it "既存のTeaProductがある場合は新しく作成せず更新すること" do
      product = create(:tea_product)
      submission.update(tea_product: product)

      expect {
        submission.approve!(admin)
      }.not_to change(TeaProduct, :count)

      expect(product.reload.name).to eq submission.name
    end
  end

  describe "#reject!" do
    let(:submission) { create(:tea_product_submission, :to_be_pending) }

    it "却下理由を保存し、ステータスがrejectedになること" do
      submission.reject!(admin, reason: "画像が不鮮明です")
      expect(submission.status).to eq "rejected"
      expect(submission.rejection_reason).to eq "画像が不鮮明です"
    end
  end

  describe "#build_resubmission" do
    let(:old_submission) { create(:tea_product_submission, :to_be_pending, status: :rejected, rejection_reason: "ダメです") }

    it "元の情報を引き継いだ新しい下書きレコードが作成されること" do
      new_submission = old_submission.build_resubmission

      expect(new_submission.status).to eq "draft"
      expect(new_submission.name).to eq old_submission.name
      expect(new_submission.previous_submission_id).to eq old_submission.id
      expect(new_submission.rejection_reason).to be_nil
    end
  end

  describe "#resolve_brand!" do
    it "brand_idが渡された時、そのブランドをセットすること" do
      brand = create(:brand)
      submission = build(:tea_product_submission)
      submission.resolve_brand!(brand_id: brand.id, brand_name: nil)
      expect(submission.brand).to eq brand
    end

    it "brand_nameが渡された時、新しいブランドを下書き状態で作成すること" do
      submission = build(:tea_product_submission, user: user)
      expect {
        submission.resolve_brand!(brand_id: nil, brand_name: "新しいお茶ブランド")
      }.to change(Brand, :count).by(1)

      # 修正点：Brandモデルの正規化によりカタカナで保存されるため、期待値をカタカナにする
      expect(submission.brand.name_ja).to eq "新シイオ茶ブランド"
      expect(submission.brand.status).to eq "draft"
    end
  end
end
