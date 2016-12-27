class OfferImportsController < ApplicationController
  before_action :set_offer_import, only: [:show, :edit, :update, :destroy]

  # GET /offer_imports
  # GET /offer_imports.json
  def index
    com_id= params[:compare]
    if com_id 
      @offer_imports = Compare.find(com_id).offer_imports.where(params[:compare])
      @variant_imports = Compare.find(com_id).variant_imports.where(params[:compare])
    else
       @offer_imports = OfferImport.all
       @variant_imports = OfferImport.all
    end

  end

  # GET /offer_imports/1
  # GET /offer_imports/1.json
  def show
  end

  # GET /offer_imports/new
  def new
    com_id= params[:compare]
    @offer_import = OfferImport.new
    @offer_import.compare_id =com_id
  end

  # GET /offer_imports/1/edit
  def edit
  end

  # POST /offer_imports
  # POST /offer_imports.json
  def create
    c= Compare.find(params[:compare])
    c.offer_imports<< OfferImport.new(offer_import_params)
  #  @offer_import = OfferImport.new(offer_import_params)
    @offer_import = c.offer_imports.last
    respond_to do |format|
      if @offer_import.save
        format.html { redirect_to [@offer_import.compare.site,@offer_import], notice: 'Offer import was successfully created.' }
        format.json { render :show, status: :created, location: @offer_import }
      else
        format.html { render :new }
        format.json { render json: @offer_import.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /offer_imports/1
  # PATCH/PUT /offer_imports/1.json
  def update
    respond_to do |format|
      if @offer_import.update(offer_import_params)
        format.html { redirect_to [@offer_import.compare.site,@offer_import], notice: 'Offer import was successfully updated.' }
        format.json { render :show, status: :ok, location: @offer_import }
      else
        format.html { render :edit }
        format.json { render json: @offer_import.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /offer_imports/1
  # DELETE /offer_imports/1.json
  def destroy
    @offer_import.destroy
    respond_to do |format|
      format.html { redirect_to offer_imports_url, notice: 'Offer import was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_offer_import
      @offer_import = OfferImport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def offer_import_params
 #      params.require(:offer_import).permit(:compare)
      params.fetch(:offer_import,{})
    end
end
