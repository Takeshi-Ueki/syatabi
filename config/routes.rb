Rails.application.routes.draw do

  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  scope module: :public do
    root "homes#top"

    get 'users/:id/favorites' => 'users#favorites', as: "user_favorites"
    get 'users/:id/lists' => 'users#lists', as: "user_lists"
    get 'users/:id/check' => 'users#check', as: "user_check"
    patch 'users/:id/withdraw' => 'users#withdraw', as: "user_withdraw"
    resources :users, only: [:show, :edit, :update] do
      resource :ranks, only: [:new]
      resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: "followings"
      get 'followers' => 'relationships#followers', as: "followers"
    end


    get 'searches/search', as: "search"
    get 'posts/search_tag', as: "search_tag"
    get 'posts/:id/favorites' => 'posts#favorites', as: "post_favorites"
    resources :posts do
      resources :post_comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
      resources :lists, only: [:create, :update, :destroy]
      resources :ranks, only: [:create, :destroy]
      resource :reposts, only: [:create, :destroy]
      resources :diaries, only: [:new, :create, :show, :edit, :update, :destroy]
    end
  end

  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update]
    resources :posts, only: [:index, :show, :edit, :update]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
