class IpsController < ApplicationController
  respond_to :json
  respond_to :rdp, :ssh, :html, :only => :connect 

  def index
    net = Net.find(params[:net_id])
    respond_with(net.ips.order(:id).includes(:arp, :info), :include => [:info, :arp])
  end

  def show
    @ip = Ip.includes(:info).find(params[:id])
    if ! @ip.info 
      @ip.info = @ip.infos.new
      @ip.info.save
      @ip.update_last_info
    end
    @users_json = User.select([:id, :login]).all.inject(" {") {|t, u| t += "'#{u.id}':'#{u.login}', "} + "}"
    render :layout => false
  end

  def protocol
    @ip = Ip.find(params[:id])
    if params[:protocol] 
      @ip.update_attributes(:conn_proto => params[:protocol])
      respond_with(@ip)
    else 
    end
  end

  def notify
    @ip = Ip.find(params[:id])
    @ip.update_attribute(:notify, ! @ip.notify)
    respond_with(@ip.notify)
  end

  # TODO http e' un link semplice
  def connect
    @ip = Ip.find(params[:id])
    respond_to do |format|
      format.html { redirect_to "http://#{@ip.ip}" }
      format.rdp { }
      format.ssh { }
    end
  end

end
