module ReviewsHelper

  def render_stars(score)
    full = score.to_i
    empty = 5 - full

    ("★" * full) + ("☆" * empty)
  end

end