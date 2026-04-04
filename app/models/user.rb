class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  enum :role, { general: 0, admin: 1 }

  has_many :favorites, dependent: :destroy
  # ユーザーがお気に入りした紅茶の一覧を簡単に取得できるようにする
  has_many :favorite_tea_products, through: :favorites, source: :tea_product
  has_many :reviews, dependent: :destroy

  has_many :tea_product_submissions, dependent: :destroy

  # 投稿者として
  has_many :brands
  has_many :tea_products

  # 承認者として
  has_many :approved_brands,
           class_name: "Brand",
           foreign_key: :approved_by_id

  has_many :approved_tea_products,
           class_name: "TeaProduct",
           foreign_key: :approved_by_id

  def self.from_omniauth(auth)
    user = find_by(provider: auth.provider, uid: auth.uid)

    user ||= find_or_initialize_by(email: auth.info.email)

    user.assign_attributes(
      provider: auth.provider,
      uid: auth.uid,
      email: auth.info.email
    )

    if user.new_record?
      user.password = Devise.friendly_token[0, 20]
    end

    user.name = auth.info.name if user.respond_to?(:name)

    user.save
    user
  end
end
