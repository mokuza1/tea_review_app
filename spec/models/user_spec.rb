require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション" do
    it "有効なfactoryを持つ" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "emailがないと無効" do
      user = build(:user, email: nil)
      expect(user).to be_invalid
    end

    it "emailは一意であること" do
      create(:user, email: "test@example.com")
      user = build(:user, email: "test@example.com")
      expect(user).to be_invalid
    end

    it "passwordがないと無効" do
      user = build(:user, password: nil)
      expect(user).to be_invalid
    end
  end

  describe "enum" do
    it "generalがデフォルトであること" do
      user = build(:user)
      expect(user.role).to eq "general"
    end

    it "adminに設定できること" do
      user = build(:user, role: :admin)
      expect(user.admin?).to be true
    end
  end

  describe "アソシエーション" do
    it "favoritesを複数持つ" do
      expect(User.reflect_on_association(:favorites).macro).to eq :has_many
    end

    it "reviewsを複数持つ" do
      expect(User.reflect_on_association(:reviews).macro).to eq :has_many
    end

    it "brandsを複数持つ" do
      expect(User.reflect_on_association(:brands).macro).to eq :has_many
    end

    it "tea_productsを複数持つ" do
      expect(User.reflect_on_association(:tea_products).macro).to eq :has_many
    end

    it "approved_brandsを持つ（承認者）" do
      association = User.reflect_on_association(:approved_brands)
      expect(association.macro).to eq :has_many
      expect(association.options[:class_name]).to eq "Brand"
    end

    it "approved_tea_productsを持つ（承認者）" do
      association = User.reflect_on_association(:approved_tea_products)
      expect(association.macro).to eq :has_many
      expect(association.options[:class_name]).to eq "TeaProduct"
    end
  end
end
