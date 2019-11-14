Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get 'reports/usage/:promotion_id', to: 'usage_reports#show', as: 'usage_reports'
      get 'reports/demographic/:promotion_id', to: 'demographic_reports#show', as: 'demographic_reports'
    end
  end
end
