class NetworksController < ApplicationController
  def index
    @networks = Netwok.all
  end

  def new
    @network = Network.new
  end

  def create
    @network = Network.new
    @network.name = params[:network][:name]
    if @network.save
      flash[:notice] = 'Network created'
      redirect_to home_path
    else
      render :action => :new
    end
  end
end
