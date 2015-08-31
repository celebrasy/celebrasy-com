Rails.application.routes.draw do
  resources :leagues, only: [] do
    resources :point_categories, only: [:index]
  end
end
