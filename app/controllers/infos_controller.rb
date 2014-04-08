class InfosController < ApplicationController
  respond_to :json

  # FIXME backbone sends a complete representation of the resource on save.
  # It breaks attr_accessible in model. So we need to clean up.
  def create
    @ip = Ip.find(params[:ip_id] || params[:info][:ip_id])
    @info = @ip.infos.new()
    @info.name    = params[:info][:name]
    @info.comment = params[:info][:comment]
    if @info.save
      render :json => @info
    else
      render :json => @info.errors, :status => :unprocessable_entity
    end
  end

  def update
    logger.info(params.inspect)
    @info = Info.find(params[:id])
    # do not work anymore FIXME
    #@info.name    = params[:info][:name] 
    #@info.comment = params[:info][:comment]
    @info.name    = params[:name] 
    @info.comment = params[:comment]
    if @info.save
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
