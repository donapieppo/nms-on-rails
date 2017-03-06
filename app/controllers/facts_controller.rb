class FactsController < ApplicationController
  #respond_to :html
  #respond_to :json, :only => [:show]
  respond_to :json

  def index
    @facts = Fact.includes(:ip => [:info, :arp]).order(:lsbdistrelease, 'ips.ip')
    respond_with(@facts, :include => { :ip => { :include => [ :info, :arp ]}})
  end

  def show
    if params[:ip_id]
      @ip = Ip.find(params[:ip_id])
    end

    @fact = @ip ? Fact.where(:ip_id => @ip.id).first : Fact.find(params[:id])
    respond_with(@fact)
  end

end

