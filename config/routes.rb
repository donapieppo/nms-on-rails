NmsOnRails::Application.routes.draw do
  resources :ips do
    put :protocol, :on => :member
    put :notify,   :on => :member
    get :connect,  :on => :member
    get :wake,     :on => :member
    resource :infos
  end

  resources :networks do 
    resources :ips
  end

  resources :arps
  resources :facts
  resources :infos 

  resources :switches

  root :to => 'home#index'
end
