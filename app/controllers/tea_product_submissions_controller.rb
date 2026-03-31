class TeaProductSubmissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tea_product_submission, only: %i[edit update submit]
  before_action :prepare_edit_form, only: %i[edit update submit]

  def new
    # TeaProduct ではなく Submission をビルドする
    @tea_product_submission = current_user.tea_product_submissions.build(status: :draft)
    
    tpl = @tea_product_submission.tea_product_submission_purchase_locations.build
    tpl.build_purchase_location
  end

  def create
    normalized = submission_params.dup
    brand_id   = normalized.delete(:brand_id).presence
    brand_name = normalized.delete(:brand_name).to_s.strip

    @tea_product_submission = current_user.tea_product_submissions.build(normalized)
    
    # フォーム再描画用に値を保持
    @tea_product_submission.brand_id = brand_id
    @tea_product_submission.brand_name = brand_name

    if brand_id.blank? && brand_name.blank?
      flash.now[:alert] = "ブランドを選択するか、新しく入力してください"
      prepare_edit_form
      render :new, status: :unprocessable_entity and return
    end

    @tea_product_submission.status = :draft

    begin
      ActiveRecord::Base.transaction do
        # モデルにブランドの解決・作成を任せる
        @tea_product_submission.resolve_brand!(brand_id: brand_id, brand_name: brand_name)
        @tea_product_submission.save!
      end

      # ※ルーティングに合わせて _path の名前は適宜調整してください
      redirect_to edit_tea_product_submission_path(@tea_product_submission), notice: "下書きを作成しました"
    rescue ActiveRecord::RecordInvalid => e
      prepare_edit_form
      flash.now[:alert] = "保存に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    unless @tea_product_submission.draft? || @tea_product_submission.rejected?
      redirect_to tea_products_path, alert: "編集できない状態です"
    end

    if @tea_product_submission.tea_product_submission_purchase_locations.blank?
        tpl = @tea_product_submission.tea_product_submission_purchase_locations.build
        tpl.build_purchase_location
    end
  end

  def update
    normalized = submission_params.dup
    brand_id   = normalized.delete(:brand_id).presence
    brand_name = normalized.delete(:brand_name).to_s.strip

    @tea_product_submission.brand_id = brand_id
    @tea_product_submission.brand_name = brand_name

    if brand_id.blank? && brand_name.blank?
      flash.now[:alert] = "ブランドを選択するか、新しく入力してください"
      prepare_edit_form
      render :edit, status: :unprocessable_entity and return
    end

    was_rejected = @tea_product_submission.rejected?

    begin
      ActiveRecord::Base.transaction do
        if was_rejected
          # 却下状態からの更新なら、ここで新しい下書きを生成し、操作対象を切り替える
          @tea_product_submission = @tea_product_submission.build_resubmission
        end

        @tea_product_submission.assign_attributes(normalized)
        @tea_product_submission.resolve_brand!(brand_id: brand_id, brand_name: brand_name)
        
        # もしここでバリデーションエラーになっても、@tea_product_submission には
        # ユーザーが入力した最新の属性とエラー情報が乗っている状態になる
        @tea_product_submission.save!
      end

      notice_msg = was_rejected ? "再申請用に新しい下書きを作成しました" : "下書きを更新しました"
      redirect_to edit_tea_product_submission_path(@tea_product_submission), notice: notice_msg
    rescue ActiveRecord::RecordInvalid
      prepare_edit_form
      flash.now[:alert] = "保存に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def submit
    begin
      # 最後に保存された内容を申請状態(:pending)にする
      @tea_product_submission.submit!
      
      redirect_to mypage_path, notice: "申請しました（審査をお待ちください）"
    rescue ActiveRecord::RecordInvalid
      prepare_edit_form
      flash.now[:alert] = "入力内容に不備があるため申請できません"
      render :edit, status: :unprocessable_entity
    rescue TeaProductSubmission::InvalidStatusTransition
      redirect_to tea_products_path, alert: "このデータは申請できる状態ではありません"
    end
  end

  private

  def set_tea_product_submission
    # Userの tea_product_submissions から検索する
    @tea_product_submission = current_user.tea_product_submissions
                                          .includes(
                                            :brand,
                                            tea_product_submission_purchase_locations: :purchase_location
                                          )
                                          .find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to tea_products_path, alert: "データが見つかりませんでした"
  end

  def prepare_edit_form
    return unless @tea_product_submission

    @tea_product_submission.selected_flavor_category_ids =
      params.dig(:tea_product_submission, :selected_flavor_category_ids) ||
      @tea_product_submission.flavors.pluck(:flavor_category_id).uniq
  end

  def submission_params
    params.require(:tea_product_submission).permit(
      :name,
      :brand_id,
      :brand_name,
      :tea_type,
      :caffeine_level,
      :description,
      :image,
      { selected_flavor_category_ids: [] },
      { flavor_ids: [] },
      tea_product_submission_purchase_locations_attributes: [
        :id,
        :_destroy,
        purchase_location_attributes: [
          :id,
          :location_type,
          :name
        ]
      ]
    )
  end
end