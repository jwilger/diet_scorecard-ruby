Rails.application.routes.draw do
  root to: 'daily_scorecards#today'

  get '/', to: 'daily_scorecards#today', as: 'daily_scorecard_today'

  get '/:year/:month/:day', to: 'daily_scorecards#show', as: 'daily_scorecard',
    constraints: { :year => /\d+/, :month => /\d\d?/, :day => /\d\d?/ }

  scope '/:year/:month/:day' do
    resources :meals, only: [:new, :create]
  end

  resources :meals, only: [:edit, :update, :destroy] do
    resources :foods, except: [:index, :show]
  end
end
