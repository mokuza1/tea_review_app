namespace :data_migration do
  desc "不要なTeaProduct削除（approved以外）"
  task cleanup_tea_products: :environment do
    # DRY_RUN=true rails data_migration:cleanup_tea_products で実行すると消さない
    dry_run = ENV['DRY_RUN'] == 'true'
    
    puts "=== cleanup start #{'(DRY RUN MODE)' if dry_run} ==="

    counter = 0
    TeaProduct.find_each do |product|
      raw_status = product.read_attribute_before_type_cast(:status)
      next if raw_status == 20

      puts "Target: TeaProduct ##{product.id} (status: #{raw_status})"
      
      unless dry_run
        product.destroy!
      end
      counter += 1
    end

    puts "=== cleanup done. Total: #{counter} records processed. ==="
  end
end
