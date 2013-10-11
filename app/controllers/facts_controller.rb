class FactsController < ApplicationController
  respond_to :html
  respond_to :json, :only => [:show]

  def index
    @facts = Fact.includes(:ip).all
  end

  def show
    if params[:ip_id]
      @ip = Ip.find(params[:ip_id])
    end

    @fact = @ip ? Fact.where(:ip_id => @ip.id).first : Fact.find(params[:id])
    respond_with(@fact)
  end

end

