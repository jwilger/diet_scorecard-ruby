module DailyScorecardsHelper
  def total_points_score_type(daily_scorecard)
    ratio = daily_scorecard.total_points.to_f / daily_scorecard.possible_points.to_f
    case ratio
    when 0.75..Float::INFINITY
      'success'
    when 0.5...0.75
      'info'
    when 0.25...0.5
      'warning'
    else
      'danger'
    end
  end
end
