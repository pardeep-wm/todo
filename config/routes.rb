Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    resources :todo_items do
      collection do
        get :items_by_tag 
      end
    end
  end
end
