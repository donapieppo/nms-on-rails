class IpsController < ApplicationController
  # respond_to :json
  # respond_to :rdp, :ssh, :html, :only => :connect 

  def index
    if params[:search_string] and params[:search_string].size > 1
      like_str = "%#{params[:search_string]}%"
      if params[:search_string] =~ /^[0-9]{2}$/
        @ips = Ip.where('ip LIKE ?', "%.#{params[:search_string]}").order(:id)
      elsif params[:search_string] =~ /^[0-9\.]+$/
        @ips = Ip.where('ip LIKE ?', like_str).order(:id)
      elsif params[:search_string] =~ /\w{1,2}:\w{1,2}:\w{1,2}/
        @ips = Ip.joins(:arps).where('arps.mac LIKE ?', like_str).order('ips.id')
      else
        @ips = Ip.joins(:info).where('infos.name LIKE ? OR infos.comment LIKE ?', like_str, like_str).order('ips.id')
      end
    else 
      network = params[:network_id] ? Network.find(params[:network_id]) : Network.first
      @ips = network.ips.order(:id)
    end
    @ips = @ips.includes(:arp, :info, :fact)
    respond_to do |format|
      format.json { render json: client_json(@ips.limit(255)) }
    end
  end

  def show
    @ip = Ip.includes(:info, :arp).find(params[:id])
    if ! @ip.info 
      @ip.info = @ip.infos.new
      @ip.info.save
      @ip.update_last_info
    end
    # @users_json = User.select([:id, :login]).all.inject(" {") {|t, u| t += "'#{u.id}':'#{u.login}', "} + "}"
    # respond_with(@ip, :include => {:info => {}, :arp => {}, :last_port => {:include => :switch}})
  end

  def update
    @ip = Ip.find(params[:id])
    if params[:conn_proto]
      @ip.update_attribute(:conn_proto, params[:conn_proto])
    elsif params[:system]
      info = @ip.last_info || @ip.infos.new
      info.system = (params[:system] == 'unset') ? nil : params[:system]
      info.save
    end
    render json: 'ok'
    # respond_with(@ip)
  end

  def notify
    @ip = Ip.find(params[:id])
    @ip.update_attribute(:notify, ! @ip.notify)
    respond_with(@ip.notify)
  end

  def star
    @ip = Ip.find(params[:id])
    @ip.update_attribute(:starred, ! @ip.starred)
    respond_with(@ip.starred)
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

  def new
    @network = Network.find(params[:network_id])
  end

  def create
    @network = Network.find(params[:network_id])
    base = "#{params[:n1].to_i}.#{params[:n2].to_i}.#{params[:n3].to_i}"
    (params[:start].to_i ... params[:end].to_i).each do |i|
      @network.ips.create!(:ip => "#{base}.#{i}")
    end
    redirect_to root_path
  end

  # in order to reset it is sufficient to create new arp and info
  def reset
    @ip = Ip.find(params[:id])
    logger.info("RESETTING #{@ip.inspect} from #{@ip.info.inspect}")
    @ip.infos.create!(name: '-') unless @ip.info.name == '-'
    @ip.update(last_arp_id: nil, starred: nil)
    render json: 'ok'
  end

  def client_json(ips)
    ips.map do |ip|
      {
        id: ip.id,
        info_id: (ip.info ? ip.info.id : nil), 
        ip: ip.ip, 
        dhcp: ip.dhcp,
        name: (ip.info ? ip.info.name : nil),
        comment: (ip.info ? ip.info.comment : nil),
        last_seen: (ip.arp ? ip.arp.date : 0), 
        dnsname: (ip.info ? ip.info.dnsname : nil), 
        arp: (ip.arp ? ip.arp.mac : '-'),
        system: (ip.info && ip.info.system) ? ip.info.system : 'undef',
        starred: ip.starred, 
        fact: (ip.fact ? ip.fact : nil)
      }
    end
  end
end
