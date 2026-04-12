class ReviewSummaryService
  def self.call(reviews)
    new(reviews).call
  end

  def initialize(reviews)
    @reviews = reviews
  end

  def call
    reviews
      .unscope(:includes, :eager_load)
      .select(select_sql)
      .take
  end

  private

  attr_reader :reviews

  def select_sql
    <<~SQL
      COUNT(*) AS review_count,

      AVG(overall_rating) AS overall_avg,
      AVG(aroma_rating) AS aroma_avg,
      AVG(bitterness_rating) AS bitterness_avg,
      AVG(strength_rating) AS strength_avg,
      AVG(sweetness_rating) AS sweetness_avg,

      SUM(CASE WHEN recommended_straight THEN 1 ELSE 0 END) AS recommended_straight_count,
      SUM(CASE WHEN recommended_milk THEN 1 ELSE 0 END) AS recommended_milk_count,
      SUM(CASE WHEN recommended_iced THEN 1 ELSE 0 END) AS recommended_iced_count
    SQL
  end
end
