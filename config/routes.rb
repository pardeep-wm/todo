Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    resources :todo_items do
      collection do
        get :items_by_tag
      end
      member do
        put :mark_unmark_delete
      end
    end
  end
end
