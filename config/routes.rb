NmsOnRails::Application.routes.draw do
  resources :ips do
    put :protocol, :on => :member
    put :notify,   :on => :member
    get :connect, :on => :member
    resource :infos
  end

  resources :arps
  resources :facts
  resources :infos

  match 'nets/:net' => 'ips#index'

  root :to => 'home#index'
end
