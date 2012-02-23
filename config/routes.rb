NmsOnRails::Application.routes.draw do
  resources :ips do
    put :protocol, :on => :member
    put :notify,   :on => :member
    get :connect,  :on => :member
    resource :infos
  end

  resources :nets do 
    resources :ips
  end

  resources :arps
  resources :facts
  resources :infos

  root :to => 'home#index'
end
