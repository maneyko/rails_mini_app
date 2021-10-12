Rails.application.routes.draw do
  resources :my_test_models, only: %i[index]
end
