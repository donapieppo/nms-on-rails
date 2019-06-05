class InfosController < ApplicationController
  def create
    @ip = Ip.find(params[:ip_id] || params[:info][:ip_id])
    @info = @ip.infos.new()
    @info.name    = params[:info][:name]
    @info.comment = params[:info][:comment]
    if @info.save
      render :json => @info
    else
      render :json => @info.errors, status: :unprocessable_entity
    end
  end

  def update
    logger.info(params.inspect)
    @info = Info.find(params[:id])
    @info.name    = params[:name] 
    @info.comment = params[:comment]
    if @info.save
      render :json => @info
    else
      render :json => @info.errors, status: :unprocessable_entity 
    end
  end

  # POST /infos/1/conn_proto/ssh
  def conn
    Info.find(params[:id]).update_attribute(:conn_proto, params[:proto])
  end

end
