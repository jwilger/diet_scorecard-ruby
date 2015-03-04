require 'rails_helper'

describe DailyScorecardsController do
  context 'GET request to /' do
    let(:clock) { double(:clock, now: today) }
    let(:today) { Time.zone.local(2012,10,24) }

    before(:each) do
      controller.load_services(
        clock: clock
      )
      get :today
    end

    it 'routes to the today action' do
      expect(get: '/').to route_to controller: 'daily_scorecards',
        action: 'today'
    end

    it 'redirects to the show page for the current date' do
      expect(response).to \
        redirect_to daily_scorecard_path(year: today.year,
                                         month: today.month,
                                         day: today.day)
    end
  end

  context 'GET request to /:year/:month/:day' do
    let(:daily_scorecard_service) {
      double(:daily_scorecard_service, new: :the_daily_scorecard)
    }

    let(:current_user) { double(:current_user, time_zone: Time.zone, id: 42) }

    let(:the_date) { Time.zone.local(2005,7,27) }

    let(:year) { the_date.year.to_s }
    let(:month) { the_date.month.to_s }
    let(:day) { the_date.day.to_s }

    let(:meals_service) { double(:meals_service, for_user_id: scoped_meals_service) }
    let(:scoped_meals_service) { double(:scoped_meals_service) }

    before(:each) do
      controller.load_services(
        daily_scorecards: daily_scorecard_service,
        current_user: current_user,
        meals: meals_service
      )
      get :show, year: year, month: month, day: day
    end

    it 'routes to the show action' do
      expect(get: '/2012/10/19').to route_to controller: 'daily_scorecards',
        action: 'show', year: '2012', month: '10', day: '19'
    end

    it 'responds with a 200 status' do
      expect(response.status).to eq 200
    end

    it 'renders the daily_scorecards/show template' do
      expect(response).to render_template 'daily_scorecards/show'
    end

    it 'renders as HTML' do
      expect(response.content_type).to eq 'text/html'
    end

    it 'builds a DailyScorecard for the specified date' do
      expect(daily_scorecard_service).to have_received(:new) \
        .with(date: the_date, meals_service: scoped_meals_service)
    end

    it 'scopes the meals service down to the current user' do
      expect(meals_service).to have_received(:for_user_id).with(current_user.id)
    end

    it 'exposes the DailyScorecard to the template' do
      expect(controller.daily_scorecard).to eq :the_daily_scorecard
    end
  end
end
