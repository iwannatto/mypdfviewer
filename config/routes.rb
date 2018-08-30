Rails.application.routes.draw do
  resources :pdfs, format: false
  root to: 'pdfs#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
