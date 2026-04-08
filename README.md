# みんなの紅茶図鑑
<img width="837" height="370" alt="みんなの 紅茶図鑑" src="https://github.com/user-attachments/assets/19bae860-a662-4d29-abe6-08f932ea09d4" />

## サービスURL
https://www.kocha-zukan.com/

## サービス概要
- 紅茶の商品情報をブランド横断で検索できるデータベースアプリです。
- フレーバーや茶葉タイプなどのスペックから、初心者でも簡単に紅茶を探せます。
- また、ユーザーによる「味の濃さ」「香りの強さ」などのライトレビューも確認できます。

## このサービスへの思い・作りたい理由
紅茶について情報を探すと、個人ブログが検索の大半を占めており、
紅茶の“レビュー中心の感想”が情報のメインになってしまう現状があります。  
しかし、例えば「ローズフレーバーの紅茶が知りたい」と思って調べると、
ブランドごとにサイトを巡回したり、まとまりのないブログを読むしかありません。

紅茶に興味を持ち始めた初心者が、  
**「気になるフレーバーとブランドを横断的に比較できる、入門しやすい辞典」**  
があれば便利なのに、現状存在しません。

そこで、レビューに偏らず、
**「紅茶のスペックを軸に検索できる辞典型アプリ」**を作りたいと思いました。  
初心者でも気軽に紅茶を発見できる、そんな場を提供したいという思いから、このサービスを企画しました。

## ユーザー層について
#### ① 紅茶に興味が出てきた初心者
アフターヌーンティーブームにより紅茶への関心が高まっている層  
しかし深い知識がなく、どのブランドのどの商品を買えばいいか分からない  
レビューよりもまずフレーバーやスペックを知りたい  
→ この層にとって「調べやすい辞典型アプリ」は最も価値を発揮する

#### ② 日常的に紅茶を飲むライトユーザー
好きなフレーバーを探したいが、情報を集めるのが面倒  
「香りが強いもの」「ミルクティーに向くもの」などを探したい  
→ 味の強弱・香りのレビューが役に立つ

#### ③ 紅茶に詳しいユーザー（情報提供者）
新商品を登録したり、簡易レビューを投稿できる  
自分が飲んだ紅茶の記録にしたい  
→ サービスを“育てる役割”も担える

## サービスの利用イメージ
- ユーザーはフレーバー（フルーツ/ シトラス、ベリー、アップル）や茶葉タイプから紅茶を検索できる
![VideoProject-ezgif com-video-to-gif-converter (1)](https://github.com/user-attachments/assets/686a6202-6969-4647-ad7d-d6e4ffbb37aa)






- ブランド横断で商品一覧を比較できる
- 商品ページでは「香りの強さ」「味の濃さ」「渋み」などの統一されたレビューを確認可能
- 気になった紅茶が、自分に合いそうかどうかを短時間で判断できる
- ユーザー自身も、商品追加やライトレビューでデータベースを育てられる

## ユーザーの獲得について
- **SNSでのシェア機能**  
　紅茶を投稿したユーザーが SNS にシェアしやすくし、新規ユーザーを流入させる
- **アフターヌーンティー好きコミュニティや X（旧Twitter）の紅茶層**  
　レビュー文化がすでにあるためハマりやすい

## サービスの差別化ポイント・推しポイント
#### ① フレーバーやスペックから紅茶を横断検索できる唯一のアプリ
個人ブログは感想中心で、比較が困難。
既存のレビューサイトも紅茶に特化していない。

→ 本アプリは検索軸が“スペックとフレーバー”に特化しており、
ブランド横断で比較できる唯一の存在となる。

#### ② レビューは長文ではなく“定量評価”に特化
- 香りの強さ
- 味の濃さ
- 渋み
- ミルクティー向けか  
初心者が知りたい情報に限定し、見やすさを徹底。  
また、定数によるライトレビューで回答に対するハードルを下げる。

#### ③ 商品追加もユーザー参加型で、辞典が育つ構造
運営負担を減らしつつ、情報が自然に増えていく。

## 機能候補
### MVP
#### まずは「ブランドを横断して紅茶を検索し、情報を共有できるデータベース」としてのコア機能を実装しています。
| 機能 | 概要 |
|---------|-----------|
| ユーザー認証 | メールアドレスによる新規登録・ログイン機能 |
| 商品投稿 | 画像付きの商品情報登録。ActiveStorageを用いて画像を管理 |
| 商品検索 | ブランド、フレーバー、フリーワードを組み合わせた複合検索 |
| 商品一覧・詳細表示 | 登録された紅茶情報の閲覧機能 |
| マイページ | 自身が投稿した商品の一覧管理 |
| 管理者機能（基礎） | 投稿内容の承認フロー、フレーバーカテゴリやブランド情報の管理 |


### 本リリース
#### 検索の利便性を高め、ユーザー同士が「定量的なデータ」で繋がるための機能を拡充しました。
| カテゴリ | 機能 | 概要 |
|---------|-----------|--------------|
| 利便性 | 診断機能 | 初心者でも質問への回答から最適なフレーバーを提案 |
|  | 多角的な商品検索 | カフェインレベルや茶葉タイプによる絞り込みを追加 |
|  | Googleログイン | ソーシャルログインによる登録ハードルの緩和 |
| コミュニケーション | ライトレビュー | 香り・渋み等の5段階評価、ストレート・ミルク等の飲み方提案（チェックボックス）による定量評価 |
|  | お気に入り機能 | 気になる紅茶を保存し、後から参照できるストック機能 |
|  | SNS（X）共有 | 診断結果を外部へシェアする機能 |
| 運用 | 管理者機能（詳細） | 承認履歴の管理、投稿拒否時の理由明示機能による透明性の確保 |
|  | その他 | パスワード再設定、利用規約・プライバシーポリシー等の整備。サイト概要の追加 |


### 今後の拡張予定
- 自由タグ機能：ユーザーによる自由な口コミ補助
- レコメンド機能：レビューデータに基づき、好みに近い紅茶を自動表示
- 廃盤、限定商品報告：情報の鮮度を保つためのユーザー通報システム
- ランキング：「香りの強さ順」など、定量評価を活かした独自ランキング

## 🛠️使用する技術スタック
| カテゴリ | 主要技術 | 備考・ツール |
|---------|-----------|--------------|
| バックエンド | Ruby on Rails 8.1 | Ruby 3.3.6 |
| フロントエンド | Hotwire（Turbo / Stimulus） | Tailwind CSS / esbuild |
| データベース | PostgreSQL / Redis | Solid Cache / Active Job |
| 認証・認可 | Devise | OmniAuth（Google OAuth） |
| ライブラリ | Ransack / Kaminari | 検索・ページネーション |
| ストレージ | ActiveStorage | AWS S3 / ImageProcessing |
| インフラ | Render | GitHub Actions（CI/CD） / Resend |
| セキュリティ | Rack::Attack | Brakeman / bundler-audit |
| テスト | RSpec | FactoryBot / Capybara / SimpleCov |
| 開発環境 | Docker | RuboCop / Bullet / Pry |

## 🛠️選定理由
### **Docker**
- OS などの環境に依存せず、誰がどこで開発しても同じ動作を保証するため。

### **Ruby on Rails 8.1**
- 最新バージョンを採用することでHotwireなどのモダンな標準機能を活用。将来的に主流となる構成に触れ、開発経験を得るため。
- 新バージョン特有の不具合リスクはあるが、長期的な保守性を重視。
 
### **Hotwire（Turbo / Stimulus）**
- JavaScriptの記述量を抑えつつ、Railsの標準機能内でリッチなUI/UXを実現するため採用。
- モーダル表示において、Railsと親和性の高いHotwireを使うことで、開発効率を維持しながら直感的な操作感を提供している。

### **ActiveStorage + AWS S3**
- 画像データをサーバー本体から分離し、拡張性と可用性を確保するため採用。
- Rails標準のActiveStorageを利用することで実装の複雑さを避けつつ、本番環境ではクラウドストレージ（S3）を利用する実運用を意識した構成にしている。

### **Ransack**
- 本アプリのコア機能であるスペック検索において、複雑な検索条件を可読性・保守性の高い形で実装するため採用。
- 自前でクエリを書くよりも可読性が高く、将来的な検索項目の追加にも柔軟に対応できる点を評価している。

### **Googleログイン（OmniAuth）**
- 新規登録の心理的ハードルを下げるために導入。

### **Render（アプリケーション / データベース）**
- アプリケーションとデータベースを同一プラットフォーム上で管理することで、環境差異を最小化し、運用・保守コストを削減するため採用。
- 外部DBサービス（例：Neon）と比較し、構成をシンプルに保つことを優先。

### **GitHub Actions**
- PR作成ごとにRSpec・Lint・セキュリティチェックを自動実行し、コード品質を担保するため導入。
- 手動チェックの漏れを防ぎ、継続的に安全なコードを維持できる。



## 🗺️画面遷移図
参考figma：https://www.figma.com/design/gcZCgMaVid3iVncASX5k0p/%E7%94%BB%E9%9D%A2%E9%81%B7%E7%A7%BB%E5%9B%B3?node-id=0-1&t=m6drLg3N6stMioQk-1

## 📑ER図
```mermaid
erDiagram

  users {
    bigint id PK
    string email
    string encrypted_password
    string name
    integer role
    string provider
    string uid
  }

  brands {
    bigint id PK
    string name_ja
    string name_en
    string country
    text description
    integer status
    bigint user_id FK
    bigint approved_by_id FK
  }

  tea_products {
    bigint id PK
    string name
    text description
    integer tea_type
    integer caffeine_level
    integer status
    bigint brand_id FK
    bigint user_id FK
    bigint approved_by_id FK
  }

  tea_product_submissions {
    bigint id PK
    string name
    text description
    integer tea_type
    integer caffeine_level
    integer status
    text rejection_reason
    bigint brand_id FK
    bigint tea_product_id FK
    bigint previous_submission_id FK
    bigint user_id FK
    bigint approved_by_id FK
  }

  reviews {
    bigint id PK
    integer overall_rating
    integer aroma_rating
    integer bitterness_rating
    integer sweetness_rating
    integer strength_rating
    text comment
    boolean recommended_straight
    boolean recommended_milk
    boolean recommended_iced
    bigint user_id FK
    bigint tea_product_id FK
  }

  favorites {
    bigint id PK
    bigint user_id FK
    bigint tea_product_id FK
  }

  flavor_categories {
    bigint id PK
    string name
  }

  flavors {
    bigint id PK
    string name
    bigint flavor_category_id FK
  }

  tea_product_flavors {
    bigint id PK
    bigint tea_product_id FK
    bigint flavor_id FK
  }

  tea_product_submission_flavors {
    bigint id PK
    bigint tea_product_submission_id FK
    bigint flavor_id FK
  }

  purchase_locations {
    bigint id PK
    string name
    integer location_type
  }

  tea_product_purchase_locations {
    bigint id PK
    bigint tea_product_id FK
    bigint purchase_location_id FK
  }

  tea_product_submission_purchase_locations {
    bigint id PK
    bigint tea_product_submission_id FK
    bigint purchase_location_id FK
  }

  active_storage_blobs {
    bigint id PK
    string key
    string filename
  }

  active_storage_attachments {
    bigint id PK
    string name
    string record_type
    bigint record_id
    bigint blob_id FK
  }

  active_storage_variant_records {
    bigint id PK
    bigint blob_id FK
  }

  %% ========== Associations ==========

  users ||--o{ brands : creates
  users ||--o{ tea_products : creates
  users ||--o{ tea_product_submissions : creates
  users ||--o{ reviews : writes
  users ||--o{ favorites : likes

  users ||--o{ brands : approves
  users ||--o{ tea_products : approves
  users ||--o{ tea_product_submissions : approves

  brands ||--o{ tea_products : has
  brands ||--o{ tea_product_submissions : has

  tea_products ||--o{ reviews : has
  tea_products ||--o{ favorites : has
  tea_products ||--o{ tea_product_flavors : has
  tea_products ||--o{ tea_product_purchase_locations : has
  tea_products ||--o{ tea_product_submissions : original

  tea_product_submissions ||--o{ tea_product_submission_flavors : has
  tea_product_submissions ||--o{ tea_product_submission_purchase_locations : has
  tea_product_submissions ||--o{ tea_product_submissions : previous

  flavors ||--o{ tea_product_flavors : used_in
  flavors ||--o{ tea_product_submission_flavors : used_in

  flavor_categories ||--o{ flavors : has

  purchase_locations ||--o{ tea_product_purchase_locations : used_in
  purchase_locations ||--o{ tea_product_submission_purchase_locations : used_in

  active_storage_blobs ||--o{ active_storage_attachments : has
  active_storage_blobs ||--o{ active_storage_variant_records : has
```
