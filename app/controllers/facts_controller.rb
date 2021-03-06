class FactsController < ApplicationController
  def index
    @facts = Fact.includes(ip: [:info, :arp]).order(:lsbdistrelease, 'ips.ip')
    respond_to do |format|
      format.html
      format.json { render json: client_json(@facts) }
    end
  end

  def show
    if params[:ip_id]
      @ip = Ip.find(params[:ip_id])
    end

    @fact = @ip ? Fact.where(ip_id: @ip.id).first : Fact.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: client_json(@fact) }
    end
  end

  private 

  def client_json(facts)
    facts.to_json
  end
end

