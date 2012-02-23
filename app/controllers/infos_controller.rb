class InfosController < ApplicationController
  respond_to :json

  def create
    @ip = Ip.find(params[:ip_id] || params[:info][:ip_id])
    @info = @ip.infos.new(params[:info])
    if @info.save
      render :json => @info
    else
      render :json => @info.errors, :status => :unprocessable_entity
    end
  end

  def update
    @info = Info.find(params.delete(:id))
    params[:info].delete(:id)
    if @info.update_attributes(params[:info])
      render :json => @info
    else
      render :json => @info.errors, :status => :unprocessable_entity 
    end
  end

  # POST /infos/1/conn_proto/ssh
  def conn
    Info.find(params[:id]).update_attribute(:conn_proto, params[:proto])
  end

end
