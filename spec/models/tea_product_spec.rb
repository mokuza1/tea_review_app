require 'rails_helper'

RSpec.describe TeaProduct, type: :model do
  describe "バリデーション" do
    it "有効なfactoryを持つこと" do
      expect(build(:tea_product)).to be_valid
    end

    it "名前がなければ無効であること" do
      product = build(:tea_product, name: nil)
      expect(product).to be_invalid
      expect(product.errors[:name].join).to include("を入力してください")
    end

    it "名前が100文字を超えると無効であること" do
      product = build(:tea_product, name: "a" * 101)
      expect(product).to be_invalid
    end

    it "ブランドがなければ無効であること" do
      product = build(:tea_product, brand: nil)
      expect(product).to be_invalid
    end
  end

  describe "Enum設定" do
    it "適切なtea_typeを定義していること" do
      expect(TeaProduct.tea_types.keys).to include("black", "green", "oolong")
    end

    it "適切なcaffeine_levelを定義していること" do
      expect(TeaProduct.caffeine_levels.keys).to include("caffeinated", "non_caffeinated", "decaffeinated")
    end
  end

  describe "アソシエーション" do
    it "flavorsを複数持てること" do
      association = described_class.reflect_on_association(:flavors)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :tea_product_flavors
    end

    it "purchase_locationsを複数持てること" do
      association = described_class.reflect_on_association(:purchase_locations)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :tea_product_purchase_locations
    end
  end

  describe "#favorited_by?(user)" do
    let(:user) { create(:user) }
    let(:tea_product) { create(:tea_product) }

    context "ユーザーがお気に入りに登録している場合" do
      before { create(:favorite, user: user, tea_product: tea_product) }

      it "trueを返すこと" do
        expect(tea_product.favorited_by?(user)).to be true
      end
    end

    context "ユーザーがお気に入りに登録していない場合" do
      it "falseを返すこと" do
        expect(tea_product.favorited_by?(user)).to be false
      end
    end

    context "ユーザーがnilの場合" do
      it "falseを返すこと" do
        expect(tea_product.favorited_by?(nil)).to be false
      end
    end
  end
end
