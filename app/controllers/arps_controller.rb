class ArpsController < ApplicationController
  # GET /arps
  # GET /arps.xml
  def index
    @arps = Arp.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @arps }
    end
  end

  # GET /arps/1
  # GET /arps/1.xml
  def show
    @arp = Arp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @arp }
    end
  end

  # GET /arps/new
  # GET /arps/new.xml
  def new
    @arp = Arp.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @arp }
    end
  end

  # GET /arps/1/edit
  def edit
    @arp = Arp.find(params[:id])
  end

  # POST /arps
  # POST /arps.xml
  def create
    @arp = Arp.new(params[:arp])

    respond_to do |format|
      if @arp.save
        format.html { redirect_to(@arp, :notice => 'Arp was successfully created.') }
        format.xml  { render :xml => @arp, :status => :created, :location => @arp }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @arp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /arps/1
  # PUT /arps/1.xml
  def update
    @arp = Arp.find(params[:id])

    respond_to do |format|
      if @arp.update_attributes(params[:arp])
        format.html { redirect_to(@arp, :notice => 'Arp was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @arp.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /arps/1
  # DELETE /arps/1.xml
  def destroy
    @arp = Arp.find(params[:id])
    @arp.destroy

    respond_to do |format|
      format.html { redirect_to(arps_url) }
      format.xml  { head :ok }
    end
  end
end
