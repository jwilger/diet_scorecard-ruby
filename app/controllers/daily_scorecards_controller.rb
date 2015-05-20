class DailyScorecardsController < ApplicationController
  helper :food_type

  service(:clock) { Time.zone }

  service(:daily_scorecards) {
    require 'diet_scorecard/daily_scorecard'
    DietScorecard::DailyScorecard
  }

  service(:meals) { Meal }

  template_attr :daily_scorecard, :running_average_score

  def today
    render_daily_scorecard clock.now
  end

  def show
    render_daily_scorecard clock.local(params[:year], params[:month], params[:day])
  end

  private

  def scoped_meals
    @scoped_meals ||= meals.for_user_id(current_user.id)
  end

  def render_daily_scorecard(date)
    self.daily_scorecard = daily_scorecards.new(
      date: date,
      meals_service: scoped_meals
    )

    start_date = date.to_date - 6
    stop_date = date.to_date
    historical_cards = (start_date..stop_date).map { |date|
      daily_scorecards.new(date: date, meals_service: scoped_meals)
    }
    historical_total_score = historical_cards.sum(&:score)
    historical_avg = historical_total_score / historical_cards.size
    self.running_average_score = historical_avg
    render action: :show
  end
end
