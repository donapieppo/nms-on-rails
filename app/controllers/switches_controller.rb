class SwitchesController < ApplicationController
  def index
    @switches = Switch.all
  end

  def new
    @switch = Switch.new
  end

  def edit
    @switch = Switch.find(params[:id])
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
    @switch = Switch.find(params[:id])
    if @switch.update_attributes(switch_params)
      redirect_to switches_url, notice: 'The switch was successfully updated.'
    else
      render action: "edit" 
    end
  end

  def destroy
    @switch = Switch.find(params[:id])
    @switch.destroy
    redirect_to switchs_url
  end

  private

  def switch_params
    params[:switch].permit(:name, :ip, :community)
  end
end
