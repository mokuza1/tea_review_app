module PreventableDestroyIfPublished
  extend ActiveSupport::Concern

  included do
    before_destroy :prevent_destroy_if_published
  end

  private

  def prevent_destroy_if_published
    if published?
      errors.add(:base, "承認済みのため削除できません")
      throw(:abort)
    end
  end
end
