class IpsController < ApplicationController
  respond_to :json
  respond_to :rdp, :ssh, :html, :only => :connect 

  def index
    if params[:network_id]
      network = Network.find(params[:network_id])
      @ips = network.ips.order(:id).includes(:arp, :info)
    elsif params[:search]
      @ips = Ip.where('ip LIKE ?', "%#{params[:search]}%").order(:id).includes(:arp, :info)
    end
    respond_with(@ips, :include => [:info, :arp])
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

  def wake
    @ip = Ip.find(params[:id])
    respond_to do |format|
      format.wol {}
    end
  end
end
