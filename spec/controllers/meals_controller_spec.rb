require 'rails_helper'

describe MealsController do
  let(:date) { Date.new(2014,11,18) }
  let(:year) { date.year.to_s }
  let(:month) { date.month.to_s }
  let(:day) { date.day.to_s }

  let(:consumed_at) { date.to_time }

  let(:meals_service) {
    double(:meals_service, find: meal, destroy: meal, new: meal, create: meal)
  }

  let(:meal) {
    double(:meal, valid?: meal_is_valid, consumed_at: consumed_at,
           name: 'Lunchies', update_attributes: nil)
  }

  let(:meal_is_valid) { true }

  let(:current_user) { double(:current_user, time_zone: Time.zone, id: 42) }

  let(:meal_params) {{
    'name' => 'Breakfast',
    'consumed_at(1i)' => consumed_at.year.to_s,
    'consumed_at(2i)' => consumed_at.month.to_s,
    'consumed_at(3i)' => consumed_at.day.to_s,
    'consumed_at(4i)' => consumed_at.hour.to_s,
    'consumed_at(5i)' => consumed_at.min.to_s
  }}

  before(:each) do
    controller.load_services(
      meals: meals_service,
      current_user: current_user
    )
  end

  context 'GET /:year/:month/:day/meals/new' do
    before(:each) do
      get :new, year: year, month: month, day: day
    end

    it 'routes to the #new action' do
      expect(get: '/2013/10/19/meals/new').to \
        route_to(controller: 'meals', action: 'new', year: '2013', month: '10',
                 day: '19')
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

  context 'POST /:year/:month/:day/meals' do
    before(:each) do
      post :create, year: '1981', month: '9', day: '18', meal: meal_params
    end

    it 'routes to the create action' do
      expect(post: '/1981/9/18/meals').to \
        route_to(controller: 'meals', action: 'create', year: '1981',
                 month: '9', day: '18')
    end

    it 'creates a new Meal object' do
      expect(meals_service).to have_received(:create) \
        .with(meal_params)
    end

    context 'when the meal object is valid' do
      it 'redirects the user to the daily scorecard for the date of the meal' do
        expect(response).to \
          redirect_to daily_scorecard_path(year: consumed_at.year,
                                           month: consumed_at.month,
                                           day: consumed_at.day)
      end
    end

    context 'when the meal object is invalid' do
      let(:meal_is_valid) { false }

      it 'exposes the meal object to the template' do
        expect(controller.meal).to eq meal
      end

      it 'renders the meals/new template' do
        expect(response).to render_template 'meals/new'
      end

      it 'renders as HTML' do
        expect(response.content_type).to eq 'text/html'
      end

      it 'responds with a 422 status' do
        expect(response.status).to eq 422
      end
    end
  end

  context 'DELETE /meals/:id' do
    before(:each) do
      delete :destroy, id: '5'
    end

    it 'routes to the destroy action' do
      expect(delete: '/meals/5').to \
        route_to(controller: 'meals', action: 'destroy', id: '5')
    end

    it 'deletes the meal' do
      expect(meals_service).to have_received(:destroy).with('5')
    end

    it 'redirects the user to the daily scorecard page for the meal date' do
      expect(response).to \
        redirect_to daily_scorecard_path(year: year, month: month, day: day)
    end

    it 'sets the flash message that the meal was deleted' do
      expect(flash[:notice]).to eq [{key: '.meal_deleted', meal_name: meal.name}]
    end
  end

  context 'GET /meals/:id/edit' do
    it 'routes to the edit action' do
      expect(get: '/meals/6/edit').to \
        route_to(controller: 'meals', action: 'edit', id: '6')
    end

    before(:each) do
      get :edit, id: '6'
    end

    it 'finds the specified meal for the current user' do
      expect(meals_service).to have_received(:find).with('6')
    end

    it 'exposes the specified meal to the template' do
      expect(controller.meal).to eq meal
    end

    it 'responds with a 200 status' do
      expect(response.status).to eq 200
    end

    it 'renders the meals/edit template' do
      expect(response).to render_template('meals/edit')
    end

    it 'renders as HTML' do
      expect(response.content_type).to eq 'text/html'
    end
  end

  context 'PATCH /meals/:id' do
    before(:each) do
      patch :update, id: '7', meal: meal_params
    end

    it 'routes to the update action' do
      expect(patch: '/meals/7').to \
        route_to(controller: 'meals', action: 'update', id: '7')
    end

    it 'finds the specified meal' do
      expect(meals_service).to have_received(:find).with('7')
    end

    it 'updates the meal with the specified data' do
      expect(meal).to have_received(:update_attributes).with(meal_params)
    end

    context 'when the meal object is valid' do
      it 'redirects the user to the daily scorecard for the date of the meal' do
        expect(response).to \
          redirect_to daily_scorecard_path(year: consumed_at.year,
                                           month: consumed_at.month,
                                           day: consumed_at.day)
      end
    end

    context 'when the meal object is invalid' do
      let(:meal_is_valid) { false }

      it 'exposes the meal object to the template' do
        expect(controller.meal).to eq meal
      end

      it 'renders the meals/edit template' do
        expect(response).to render_template 'meals/edit'
      end

      it 'renders as HTML' do
        expect(response.content_type).to eq 'text/html'
      end

      it 'responds with a 422 status' do
        expect(response.status).to eq 422
      end
    end
  end
end
