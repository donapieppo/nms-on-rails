class NetworksController < ApplicationController
  def index
    @networks = Network.all
  end

  def new
    @network = Network.new
  end

  def create
    @network = Network.new(params[:network])
    if @network.save
      flash[:notice] = 'Network created'
      redirect_to new_network_ip_path(@network)
    else
      render :action => :new
    end
  end
end
