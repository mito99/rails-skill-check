Rails.application.routes.draw do

  root to: 'simulations#show'
  resource :simulation

  namespace :api, format: 'json' do
    namespace :v1 do
      namespace :payments do
        get 'plans', action: :get_plans
      end
    end
  end

end
