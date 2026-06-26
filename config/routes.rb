Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  mount_avo

  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#home"
  get "prayertime", to: "prayer_times#index", as: :prayertime
  get "videos", to: "videos#index", as: :videos
  get "gallery", to: "gallery#index", as: :gallery
  resources :events, only: %i[index show]
end
