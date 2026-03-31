class Admin::TeaProductSubmissionsController < Admin::BaseController
  def index
    @submissions = TeaProductSubmission
      .pending
      .includes(:user, :brand)
      .order(created_at: :desc)
  end

  def show
    @submission = TeaProductSubmission.includes(
      :user,
      :brand,
      :purchase_locations,
      flavors: :flavor_category
    ).find(params[:id])
  end

  def approve
    submission = TeaProductSubmission.find(params[:id])
    submission.approve!(current_user)

    redirect_to admin_tea_product_submissions_path, notice: "承認しました"
  rescue TeaProductSubmission::InvalidStatusTransition
    redirect_to admin_tea_product_submissions_path, alert: "承認できない状態です"
  end

  def reject
    submission = TeaProductSubmission.find(params[:id])
    reason = params[:rejection_reason].to_s.strip

    if reason.blank?
      redirect_to admin_tea_product_submission_path(submission),
                  alert: "却下理由を入力してください" and return
    end

    submission.reject!(current_user, reason: reason)

    redirect_to admin_tea_product_submissions_path, notice: "却下しました"

  rescue TeaProductSubmission::InvalidStatusTransition
    redirect_to admin_tea_product_submissions_path, alert: "却下できない状態です"
  end
end
