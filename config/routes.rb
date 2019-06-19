Rails.application.routes.draw do
  resources :ips do
    put :notify,  on: :member
    put :reset,   on: :member
    put :star,    on: :member
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

  resources :switches do
    get :connect, on: :member
  end

  get 'macs/:address' => 'macs#show'
  root to: 'home#index'
end
