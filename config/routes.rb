# frozen_string_literal: true

Rails.application.routes.draw do
  get 'users/index'

  #
  #   resources :users, only: [:create, :update, :destroy] #direct mappping
  #
  #   namespace :admin do
  #     resources :users --> /admin/users/* --->  admin/users
  #   end
  #
  #
  #   scope 'admin' do
  #     resources :users   # /admin/users/*  --> users/index
  #   end
  #
  #   scope module: 'admin' do
  #     resources :users   /users/* --> admin/users
  #   end
  #
  #   scope module: 'admin', path:'admin2' do
  #     resources :users   /admin2/users/* --> admin/users
  #   end
  #

  post 'authenticate', to: 'authentication#authenticate'
  get '/users', to: 'users#index'
  get '/users/:id', to: 'users#user_by_id' # id should always by number
  post '/users', to: 'users#create'
  put '/users/:id', to: 'users#update'
  delete '/users/:id', to: 'users#destroy'
  post '/set_cookie',  to: 'users#set_cookie'
end
