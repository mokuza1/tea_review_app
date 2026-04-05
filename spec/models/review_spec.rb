require 'rails_helper'

RSpec.describe Review, type: :model do
  describe "バリデーション" do
    it "有効なfactoryを持つこと" do
      expect(build(:review)).to be_valid
    end

    describe "評価（Rating）のバリデーション" do
      # 5つの評価項目すべてに共通するテスト
      [ :overall_rating, :aroma_rating, :bitterness_rating, :strength_rating, :sweetness_rating ].each do |rating_field|
        it "#{rating_field}がなければ無効であること" do
          review = build(:review, rating_field => nil)
          expect(review).to be_invalid
        end

        it "#{rating_field}が0以下なら無効であること" do
          review = build(:review, rating_field => 0)
          expect(review).to be_invalid
        end

        it "#{rating_field}が6以上なら無効であること" do
          review = build(:review, rating_field => 6)
          expect(review).to be_invalid
        end

        it "#{rating_field}が1から5の間なら有効であること" do
          [ 1, 3, 5 ].each do |value|
            review = build(:review, rating_field => value)
            expect(review).to be_valid
          end
        end
      end
    end

    describe "コメントのバリデーション" do
      it "140文字以内であれば有効であること" do
        review = build(:review, comment: "a" * 140)
        expect(review).to be_valid
      end

      it "141文字以上であれば無効であること" do
        review = build(:review, comment: "a" * 141)
        expect(review).to be_invalid
      end
    end

    describe "一意性のバリデーション" do
      let(:user) { create(:user) }
      let(:tea_product) { create(:tea_product) }

      it "同じユーザーが同じ商品に2回レビューできないこと" do
        # 1回目のレビューを作成
        create(:review, user: user, tea_product: tea_product)

        # 2回目のレビュー（同じユーザー、同じ商品）をビルド
        duplicate_review = build(:review, user: user, tea_product: tea_product)

        expect(duplicate_review).to be_invalid
        expect(duplicate_review.errors[:user_id].join).to include("この紅茶にはすでにレビューしています")
      end

      it "違う商品であれば、同じユーザーがレビューできること" do
        create(:review, user: user, tea_product: tea_product)
        another_product = create(:tea_product)

        expect(build(:review, user: user, tea_product: another_product)).to be_valid
      end
    end
  end

  describe "アソシエーション" do
    it "Userに属していること" do
      expect(Review.reflect_on_association(:user).macro).to eq :belongs_to
    end

    it "TeaProductに属していること" do
      expect(Review.reflect_on_association(:tea_product).macro).to eq :belongs_to
    end
  end
end
