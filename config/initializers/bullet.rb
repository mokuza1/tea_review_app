# ログインユーザー自身のレビューを表示する際、キャッシュ（current_user）が
# 優先されて includes が「未使用」と誤検知されるため無視設定
if defined?(Bullet) && Rails.env.development?
  Rails.application.config.after_initialize do
    Bullet.enable = true

    Bullet.alert = true
    Bullet.console = true
    Bullet.rails_logger = true
    Bullet.bullet_logger = true

    # 誤検知を無視
    Bullet.add_safelist type: :unused_eager_loading,
                        class_name: "Review",
                        association: :user
  end
end
