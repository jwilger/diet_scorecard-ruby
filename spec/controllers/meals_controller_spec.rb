require 'rails_helper'

describe MealsController do
  context 'GET /:year/:month/:day/meals/new' do
    it 'routes to the #new action' do
      expect(get: '/2013/10/19/meals/new').to \
        route_to(controller: 'meals', action: 'new', year: '2013', month: '10',
                 day: '19')
    end
  end
end
