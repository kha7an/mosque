Rails.application.routes.draw do
  mount_avo

  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#home"
  get "prayertime", to: "prayer_times#index", as: :prayertime
  get "videos", to: "videos#index", as: :videos
  resources :events, only: %i[index show]
end
