Rails.application.routes.draw do

  get 'sessions/new'

  root 'static_pages#home'
  get  '/book',    to: 'books#search'
  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get  '/create',  to: 'static_pages#create'
  resources :users

  resources :books do
    member do #本一覧画面からお気に入り登録をする
      post "add", to: "favorites#create"
    end
  end
  #個人ページからお気に入りを削除する
  resources :favorites, only: [:destroy]
end
