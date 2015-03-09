require 'rails_helper'

describe FoodsController do
  let(:meal_service) { double(:meal_service, find: meal) }

  let(:meal) {
    double(:meal, new_food: food, consumed_at: consumed_at, create_food: food,
           destroy_food: food, find_food: food, update_food: food)
  }

  let(:consumed_at) { Time.zone.local(2012,3,15,12,30) }
  let(:food) { double(:food, valid?: food_valid, name: 'Mystery Meat') }
  let(:food_valid) { true }

  let(:food_params) {
    Food.servings_fields.reduce({name: 'Mystery Meat'}) { |params, field|
      params.merge(field => '2')
    }
  }

  let(:current_user) {
    User.create!(email: 'testuser@example.com', password: 'testuser password').tap do |u|
      u.confirm!
    end
  }

  before(:each) do
    sign_in current_user
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

  context 'POST /meals/:meal_id/foods' do
    before(:each) do
      post :create, meal_id: '9', food: food_params
    end

    it 'routes to the create action' do
      expect(post: '/meals/9/foods').to \
        route_to(controller: 'foods', action: 'create', meal_id: '9')
    end

    it 'finds the specified meal' do
      expect(meal_service).to have_received(:find).with('9')
    end

    it 'creates a new food for the meal' do
      expect(meal).to have_received(:create_food).with(food_params)
    end

    context 'when the food is valid' do
      it 'redirects to the daily scorecard page for the date of the meal' do
        expect(response).to \
          redirect_to daily_scorecard_path(year: 2012, month: 3, day: 15)
      end
    end

    context 'when the food is invalid' do
      let(:food_valid) { false }

      it 'exposes the food to the template' do
        expect(controller.food).to eq food
      end

      it 'renders the foods/new template' do
        expect(response).to render_template('foods/new')
      end

      it 'renders as HTML' do
        expect(response.content_type).to eq 'text/html'
      end

      it 'responds with a 422 status code' do
        expect(response.status).to eq 422
      end

      it 'exposes daily_scorecard_path_params to the template' do
        expect(controller.daily_scorecard_path_params).to \
          eq({year: 2012, month: 3, day: 15})
      end
    end
  end

  context 'DELETE /meals/:meal_id/foods/:id' do
    before(:each) do
      delete :destroy, meal_id: '3', id: '5'
    end

    it 'routes to the destroy action' do
      expect(delete: '/meals/3/foods/5').to \
        route_to(controller: 'foods', action: 'destroy', meal_id: '3', id: '5')
    end

    it 'finds the specified meal' do
      expect(meal_service).to have_received(:find).with('3')
    end

    it 'deletes the food' do
      expect(meal).to have_received(:destroy_food).with('5')
    end

    it 'redirects the user to the daily scorecard page for the meal date' do
      expect(response).to \
        redirect_to daily_scorecard_path(year: 2012, month: 3, day: 15)
    end

    it 'sets the flash message that the food was deleted' do
      expect(flash[:notice]).to eq [{key: '.food_deleted', food_name: food.name}]
    end
  end

  context 'GET /meals/:meal_id/foods/:id/edit' do
    before(:each) do
      get :edit, meal_id: '6', id: '9'
    end

    it 'routes to the edit action' do
      expect(get: '/meals/6/foods/9/edit').to \
        route_to(controller: 'foods', action: 'edit', meal_id: '6', id: '9')
    end

    it 'responds with a 200 status' do
      expect(response.status).to eq 200
    end

    it 'renders the foods/edit template' do
      expect(response).to render_template('foods/edit')
    end

    it 'renders as html' do
      expect(response.content_type).to eq 'text/html'
    end

    it 'finds the specified meal' do
      expect(meal_service).to have_received(:find).with('6')
    end

    it 'finds the food' do
      expect(meal).to have_received(:find_food).with('9')
    end

    it 'exposes the food to the template' do
      expect(controller.food).to eq food
    end

    it 'exposes daily_scorecard_path_params to the template' do
      expect(controller.daily_scorecard_path_params).to \
        eq({year: 2012, month: 3, day: 15})
    end
  end

  context 'PATCH /meals/:meal_id/foods/:id' do
    before(:each) do
      patch :update, id: '6', meal_id: '9', food: food_params
    end

    it 'routes to the edit action' do
      expect(patch: '/meals/9/foods/6').to \
        route_to(controller: 'foods', action: 'update', id: '6', meal_id: '9')
    end

    it 'finds the specified meal' do
      expect(meal_service).to have_received(:find).with('9')
    end

    it 'updates the food' do
      expect(meal).to have_received(:update_food).with('6', food_params)
    end

    context 'when the food is valid' do
      it 'redirects to the daily scorecard page for the date of the meal' do
        expect(response).to \
          redirect_to daily_scorecard_path(year: 2012, month: 3, day: 15)
      end
    end

    context 'when the food is invalid' do
      let(:food_valid) { false }

      it 'exposes the food to the template' do
        expect(controller.food).to eq food
      end

      it 'renders the foods/edit template' do
        expect(response).to render_template('foods/edit')
      end

      it 'renders as HTML' do
        expect(response.content_type).to eq 'text/html'
      end

      it 'responds with a 422 status code' do
        expect(response.status).to eq 422
      end

      it 'exposes daily_scorecard_path_params to the template' do
        expect(controller.daily_scorecard_path_params).to \
          eq({year: 2012, month: 3, day: 15})
      end
    end
  end
end
