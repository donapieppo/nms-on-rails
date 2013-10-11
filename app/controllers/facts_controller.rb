class FactsController < ApplicationController
  respond_to :html

  def index
    @facts = Fact.includes(:ip).all
  end

  def show
    @fact = Fact.includes(:ip).find(params[:id])
  end

end

