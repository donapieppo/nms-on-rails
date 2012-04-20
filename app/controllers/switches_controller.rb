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
    @switch = Switch.new(params[:switch])
    if @switch.save
      redirect_to switches_url
    else
      render :action => "new" 
    end
  end

  def update
    @switch = Switch.find(params[:id])
    if @switch.update_attributes(params[:switch])
      redirect_to(@switch, :notice => 'Switch was successfully updated.') 
    else
      render :action => "edit" 
    end
  end

  def destroy
    @switch = Switch.find(params[:id])
    @switch.destroy
    redirect_to switchs_url
  end
end
