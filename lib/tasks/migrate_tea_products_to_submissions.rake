namespace :data_migration do
  desc "TeaProduct → TeaProductSubmission 移行"
  task migrate_to_submissions: :environment do
    puts "=== データ移行開始 ==="

    TeaProduct.includes(:flavors, :purchase_locations, image_attachment: :blob).find_each do |product|
      begin
        # --- ステータス取得 ---
        raw_status = product.read_attribute_before_type_cast(:status)

        submission_status =
          case raw_status
          when 0  then :draft
          when 10 then :pending
          when 15 then :rejected
          when 20 then :approved
          else :draft
          end

        # --- 重複防止 ---
        if submission_status == :approved &&
           TeaProductSubmission.exists?(tea_product_id: product.id)
          puts "skip #{product.id}"
          next
        end

        ActiveRecord::Base.transaction do
          submission = TeaProductSubmission.new(
            user_id: product.user_id,
            approved_by_id: product.approved_by_id,
            brand_id: product.brand_id,
            caffeine_level: product.read_attribute_before_type_cast(:caffeine_level),
            tea_type: product.read_attribute_before_type_cast(:tea_type),
            description: product.description,
            name: product.name,
            rejection_reason: submission_status == :rejected ? product.rejection_reason : nil,
            status: submission_status,
            created_at: product.created_at,
            updated_at: product.updated_at,
            approved_at: product.approved_at
          )

          submission.tea_product_id = product.id if submission_status == :approved

          submission.save!(validate: false)

          # フレーバー
          product.flavors.each do |flavor|
            TeaProductSubmissionFlavor.create!(
              tea_product_submission_id: submission.id,
              flavor_id: flavor.id
            )
          end

          # 購入場所
          product.purchase_locations.each do |location|
            TeaProductSubmissionPurchaseLocation.create!(
              tea_product_submission_id: submission.id,
              purchase_location_id: location.id
            )
          end

          # 画像
          submission.image.attach(product.image.blob) if product.image.attached?

          # 非公開データの扱い
          # product.destroy! ← 本番では一旦コメントアウト推奨

          puts "migrated #{product.id}"
        end

      rescue => e
        puts "ERROR #{product.id}: #{e.message}"
      end
    end

    puts "=== 完了 ==="
  end
end
