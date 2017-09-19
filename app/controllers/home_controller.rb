class HomeController < ApplicationController
  def index
    @default_network = Network.first
    redirect_to new_network_path unless @default_network
  end
end

