Rails.application.routes.draw do
  namespace :public do
    get 'reports/new'
  end
  namespace :admin do
    get 'reports/index'
    get 'reports/show'
  end
  namespace :public do
    get 'notifications/index'
  end
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions",
  }

  devise_scope :user do
    post 'users/guest_sign_in' => 'public/sessions#guest_sign_in'
  end

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions",
  }

  scope module: :public do
    root "homes#top"

    resources :notifications, only: [:index]
    resources :ranks, only: [:create]

    resources :users, only: [:show, :edit, :update, :destroy] do
      member do
        get 'favorites'
        get 'lists'
        get 'check'
        patch 'withdraw'
      end
      collection do
        get 'account_recovery'
      end
      resources :reports, only: [:create]
      resources :ranks, only: [:index]
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
      resource :reposts, only: [:create, :destroy]
      resources :diaries, only: [:new, :create, :show, :edit, :update, :destroy]
    end
  end

  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update]
    resources :posts, only: [:index, :show, :edit, :update] do
      resources :post_comments, only: :update
    end
    resources :reports, only: [:index, :show, :update]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
