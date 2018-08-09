Rails.application.routes.draw do
  resources :ips do
    put :notify,  on: :member
    put :reset,   on: :member
    get :connect, on: :member
    get :wake,    on: :member
    resource :infos
    resource :facts
  end

  resources :networks do 
    resources :ips
  end

  resources :facts
  resources :infos 

  resources :switches

  get 'macs/:address' => 'macs#show'
  root :to => 'home#index'
end
