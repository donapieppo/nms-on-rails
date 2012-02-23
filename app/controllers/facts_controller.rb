class FactsController < ApplicationController
  respond_to :html

  def index
    @facts = Fact.includes(:ip).all
  end

end

