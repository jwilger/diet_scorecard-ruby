require 'rails_helper'

describe FoodsController do
  let(:meal_service) { double(:meal_service, find: meal) }
  let(:meal) { double(:meal, new_food: food, consumed_at: consumed_at) }
  let(:food) { double(:food) }
  let(:consumed_at) { Time.zone.local(2012,3,15,12,30) }

  before(:each) do
    controller.load_services(meals: meal_service)
  end

  context 'GET /meals/:meal_id/foods/new' do
    before(:each) do
      get :new, meal_id: '6'
    end

    it 'routes to the new action' do
      expect(get: '/meals/6/foods/new').to \
        route_to(controller: 'foods', action: 'new', meal_id: '6')
    end

    it 'responds with a 200 status' do
      expect(response.status).to eq 200
    end

    it 'renders the foods/new template' do
      expect(response).to render_template('foods/new')
    end

    it 'renders as html' do
      expect(response.content_type).to eq 'text/html'
    end

    it 'finds the specified meal' do
      expect(meal_service).to have_received(:find).with('6')
    end

    it 'builds a new food for the specified meal' do
      expect(meal).to have_received(:new_food)
    end

    it 'exposes the food to the template' do
      expect(controller.food).to eq food
    end

    it 'exposes daily_scorecard_path_params to the template' do
      expect(controller.daily_scorecard_path_params).to \
        eq({year: 2012, month: 3, day: 15})
    end
  end
end
