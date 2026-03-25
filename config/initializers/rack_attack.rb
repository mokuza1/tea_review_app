# config/initializers/rack_attack.rb
class Rack::Attack
  # 1. Redisなど、キャッシュストアの設定（Railsのキャッシュを流用）
  Rack::Attack.cache.store = ActiveSupport::Cache.lookup_store(:redis_cache_store) if Rails.env.production?

  ### パスワードリセット制限の定義 ###

  # 共通の設定: パスワードリセットのPOSTリクエストを特定
  def self.password_reset_request?(req)
    req.path == '/users/password' && req.post?
  end

  # A. IPアドレス制限 (1分間に5回まで)
  throttle('password_reset/ip', limit: 5, period: 1.minute) do |req|
    req.ip if password_reset_request?(req)
  end

  # B. メールアドレス制限 (1分間に3回まで)
  # 同一メールアドレスを狙った執拗な攻撃を防ぐ
  throttle('password_reset/email', limit: 3, period: 1.minute) do |req|
    if password_reset_request?(req)
      # normalize_emailなどは適宜調整
      req.params.dig('user', 'email').to_s.downcase.strip.presence
    end
  end

  # C. 全体制限 (1分間に20回まで)
  # サーバー全体の負荷保護
  throttle('password_reset/global', limit: 20, period: 1.minute) do |req|
    'global' if password_reset_request?(req)
  end

  # 制限時のレスポンス
  self.throttled_response = lambda do |env|
    req = Rack::Request.new(env)

    # パスワードリセット画面へのリダイレクト処理
    if password_reset_request?(req)
      [
        302,
        { 'Location' => '/users/password/new?throttled=true' },
        []
      ]
    else
      # その他のパス（ログインなど）で制限にかかった場合は標準的なエラーを返す
      [429, { 'Content-Type' => 'text/plain' }, ['Too Many Requests']]
    end
  end
end