Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get 'reports/usage', to: 'usage_reports#show', as: 'usage_reports'
  get 'reports/demographic', to: 'demographic_reports#show', as: 'demographic_reports'
end
