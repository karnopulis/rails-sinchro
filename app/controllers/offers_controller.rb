include ComparesHelper


class OffersController < ApplicationController

  before_action :set_offer, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, :except => :public
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
  # GET /offers
  # GET /offers.json
  def index
    com_id= params[:compare]
    if com_id 
      @offers = Compare.find(com_id).offers.where(params[:compare]).order(:scu).page(params[:page]).per(50)
    else
      @offers = Offer.all.order(:scu).page(params[:page]).per(50)
    end

    
    
  end

  # GET /offers/1
  # GET /offers/1.json
  def show


  end

  # GET /offers/new
  def new
    com_id= params[:compare]
    @offer = Offer.new
    @offer.compare_id =com_id
  end

  # GET /offers/1/edit
  def edit
  end

  # POST /offers
  # POST /offers.json
  def create
    c= Compare.find(params[:compare])
    c.offers<< Offer.new(offer_params)
  #  @offer = Offer.new(offer_params)
    @offer = c.offers.last

    respond_to do |format|
      if @offer.save
        format.html { redirect_to [@offer.compare.site,@offer], notice: 'offer was successfully created.' }
        format.json { render :show, status: :created, location: @offer }
      else
        format.html { render :new }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /offers/1
  # PATCH/PUT /offers/1.json
  def update
    respond_to do |format|
      if @offer.update(offer_params)
        format.html { redirect_to [@offer.compare.site,@offer], notice: 'offer was successfully updated.' }
        format.json { render :show, status: :ok, location: @offer }
      else
        format.html { render :edit }
        format.json { render json: @offer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offers/1
  # DELETE /offers/1.json
  def destroy
    @offer.destroy
    respond_to do |format|
      format.html { redirect_to site_offers_url, notice: 'offer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_offer
      @offer = Offer.find(params[:id])
      flat = @offer.characteristics.includes(:property).pluck(
            "properties.title,
            characteristics.title").to_h.values_at(*@offer.compare.site.site_offer_order)
      @par= flat.join(";")

      var = @offer.variants.first
      if var
              flat = var.prices.pluck( "title, value").to_h
              flat = flat.values_at(*@offer.compare.site.site_variant_order)
      @chr=  [@offer.scu,var.quantity,*flat].join(";") 
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def offer_params
      params.require(:offer).permit(:title,:flat,:scu,:original_id,:sort_weight)
    end
end
