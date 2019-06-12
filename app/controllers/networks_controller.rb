class NetworksController < ApplicationController
  def index
    @networks = Network.all
  end

  def new
    @network = Network.new
  end

  def create
    @network = Network.new(params.require(:network).permit(:name, :description))
    if @network.save
      flash[:notice] = 'Network created'
      redirect_to new_network_ip_path(@network)
    else
      render action: :new
    end
  end

  def edit
    @network = Network.find(params[:id])
  end
end
