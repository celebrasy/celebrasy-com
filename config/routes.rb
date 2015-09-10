Rails.application.routes.draw do
  resources :leagues, only: [] do
    resources :point_categories, only: [:index]
    resources :point_submissions, only: [:new, :create, :index]
    resources :positions, only: [:index]
    resources :players, only: [:index, :new, :create]
    resources :teams, only: [:show, :edit, :update, :index]
  end
end
