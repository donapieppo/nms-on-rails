class SwitchesController < ApplicationController
  before_action :get_switch,  only: [:show, :edit, :update, :destroy, :connect]

  def index
    @switches = Switch.all
    respond_to do |format|
      format.html
      format.json { render json: client_json(@switches) }
    end
  end

  def new
    @switch = Switch.new
  end

  def edit
  end

  def create
    @switch = Switch.new(switch_params)
    if @switch.save
      redirect_to switches_url, notice: "The switch was successfully created."
    else
      render action: "new" 
    end
  end

  def update
    if @switch.update_attributes(switch_params)
      redirect_to switches_url, notice: 'The switch was successfully updated.'
    else
      render action: "edit" 
    end
  end

  def destroy
    @switch.destroy
    redirect_to switches_path
  end

  def connect
    respond_to do |format|
      format.html { redirect_to "http://#{@switch.ip}" }
      format.rdp { }
      format.ssh { }
    end
  end

  private

  def switch_params
    params[:switch].permit(:name, :ip, :community)
  end

  def get_switch
    @switch = Switch.find(params[:id])
  end

  def client_json(switches)
    switches.map do |switch|
      {
        id: switch.id,
        ip: switch.ip, 
        name: switch.name,
        community: switch.community
      }
    end
  end
end
