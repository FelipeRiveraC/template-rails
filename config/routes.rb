Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
  }
  

  namespace :api, path: 'api', defaults: { format: 'json' } do
    # Test
    get 'test', to: 'test#index'
    get 'test/authorized', to: 'test#authorized'
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
