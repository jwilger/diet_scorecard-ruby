require 'rails_helper'

describe MealsController do
  context 'GET /:year/:month/:day/meals/new' do
    it 'routes to the #new action' do
      expect(get: '/2013/10/19/meals/new').to \
        route_to(controller: 'meals', action: 'new', year: '2013', month: '10',
                 day: '19')
    end

    let(:date) { Date.new(2014,11,18) }
    let(:year) { date.year.to_s }
    let(:month) { date.month.to_s }
    let(:day) { date.day.to_s }

    let(:meals_service) { double(:meals_service, new: meal) }
    let(:meal) { double(:meal) }

    let(:current_user) { double(:current_user, time_zone: Time.zone) }

    before(:each) do
      controller.load_services(
        meals: meals_service,
        current_user: current_user
      )
      get :new, year: year, month: month, day: day
    end

    it 'responds with a 200 status' do
      expect(response.status).to eq 200
    end

    it 'renders the meals/new template' do
      expect(response).to render_template 'meals/new'
    end

    it 'renders as HTML' do
      expect(response.content_type).to eq 'text/html'
    end

    it 'builds a new Meal object with the date from the URL params' do
      expect(meals_service).to have_received(:new) \
        .with(consumed_at: date.beginning_of_day)
    end

    it 'assigns the Meal object to the template' do
      expect(controller.meal).to eq meal
    end
  end
end
