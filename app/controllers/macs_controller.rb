class MacsController < ApplicationController
  # FIXME 
  # unify mac address dormat :01: equal :1:
  def show
    @mac = params[:address].gsub(/:0(\w)/, ':\1').gsub(/^0(\w)/, '\1')
    @mac or redirect_to root_path
    @ports = Port.where(:mac => @mac)
    @arps  = Arp.where(:mac => params[:address])
  end
end
