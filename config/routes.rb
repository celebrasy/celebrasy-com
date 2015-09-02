Rails.application.routes.draw do
  resources :leagues, only: [] do
    resources :point_categories, only: [:index]
    resources :positions, only: [:index]
    get :standings
  end
end
