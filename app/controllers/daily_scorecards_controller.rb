class DailyScorecardsController < ApplicationController
  helper :food_type

  service(:clock) { Time.zone }

  service(:daily_scorecards) {
    require 'diet_scorecard/daily_scorecard'
    DietScorecard::DailyScorecard
  }

  service(:meals) { Meal }

  template_attr :daily_scorecard

  def today
    date = clock.now
    redirect_to daily_scorecard_path(year: date.year, month: date.month,
                                     day: date.day)
  end

  def show
    date = clock.local(params[:year], params[:month], params[:day])
    self.daily_scorecard = daily_scorecards.new(
      date: date,
      meals_service: meals.for_user_id(current_user.id)
    )
    render
  end
end
