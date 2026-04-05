require 'rails_helper'

RSpec.describe Brand, type: :model do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  describe "バリデーション" do
    it "有効なfactoryを持つこと" do
      expect(build(:brand)).to be_valid
    end

    it "名前（日本語）がなければ無効であること" do
      brand = build(:brand, name_ja: nil)
      expect(brand).to be_invalid
      expect(brand.errors[:name_ja]).to include("を入力してください")
    end

    it "名前（日本語）が重複していれば無効であること" do
      create(:brand, name_ja: "ダージリン")
      brand = build(:brand, name_ja: "ダージリン")
      expect(brand).to be_invalid
      expect(brand.errors[:name_ja]).to include("はすでに存在します")
    end
  end

  describe "正規化コールバック (normalize_name_ja)" do
    it "保存前に名前（日本語）の空白を除去し、カタカナに変換すること" do
      # 「あーるぐれい 」(ひらがな+末尾スペース) を入力
      brand = create(:brand, name_ja: "あーるぐれい ")
      expect(brand.name_ja).to eq "アールグレイ"
    end
  end

  describe "ステータス遷移" do
    let(:brand) { create(:brand, status: :pending) }

    describe "#approve!" do
      it "ステータスをpublishedに変更し、承認者と日時を記録すること" do
        expect {
          brand.approve!(admin)
        }.to change { brand.status }.from("pending").to("published")
        
        expect(brand.approved_by).to eq admin
        expect(brand.approved_at).to be_present
      end

      it "pending以外の状態で実行するとエラーを投げること" do
        draft_brand = create(:brand, status: :draft)
        expect { draft_brand.approve!(admin) }.to raise_error(Brand::InvalidStatusTransition)
      end
    end
  end

  describe "スコープ" do
    it ".publishedは公開済みのブランドのみを返すこと" do
      published_brand = create(:brand, status: :published)
      draft_brand = create(:brand, status: :draft)
      
      expect(Brand.published).to include(published_brand)
      expect(Brand.published).not_to include(draft_brand)
    end
  end
end