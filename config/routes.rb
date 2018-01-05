Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'api/sessions' }
  namespace :api do
    namespace :v1 do
      resources :ideas
      get 'search', to: 'ideas#search'
      put 'upload_image', to: 'ideas#image_upload'
    end
  end
end
