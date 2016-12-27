class ComparesController < ApplicationController
  before_action :set_compare, only: [:show, :edit, :update, :destroy]

  # GET /compares
  # GET /compares.json
  def index
    @compares = Compare.all
    

    
  end

  # GET /compares/1
  # GET /compares/1.json
  def show
    rez = @compare.try(:result)
    @nc =rez.try(:new_collections)
    @oc =rez.try(:old_collections)
    @no =rez.try(:new_offers)
    @oo =rez.try(:old_offers)
    @nco =rez.try(:new_collects)
    @oco =rez.try(:old_collects)
    @eo =rez.try(:edit_offers)
    @ev =rez.try(:edit_variants)
    @np =rez.try(:new_pictures)
    @op =rez.try(:old_pictures)
    
    
  end

  # GET /compares/new
  def new
    @compare = Compare.new
    @compare.site_id = params[:site_id]
  end

  # GET /compares/1/edit
  def edit
  end

  # POST /compares
  # POST /compares.json
  def create
    @compare = Compare.new(compare_params)
    @compare.site_id = params[:site_id]


    respond_to do |format|
      if @compare.save
        format.html { redirect_to [@compare.site,@compare], notice: 'Compare was successfully created.' }
        format.json { render :show, status: :created, location: @compare }
      else
        format.html { render :new }
        format.json { render json: @compare.errors, status: :unprocessable_entity }
      end
    end
    Thread.new do
      @compare.getData
      @compare.compareData
    ActiveRecord::Base.connection.close
end
  end

  # PATCH/PUT /compares/1
  # PATCH/PUT /compares/1.json
  def update
    respond_to do |format|
      if @compare.update(compare_params)
        format.html { redirect_to [@compare.site,@compare], notice: 'Compare was successfully updated.' }
        format.json { render :show, status: :ok, location: @compare }
      else
        format.html { render :edit }
        format.json { render json: @compare.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /compares/1
  # DELETE /compares/1.json
  def destroy
    @compare.destroy
    respond_to do |format|
      format.html { redirect_to site_compares_url, notice: 'Compare was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_compare
      @compare = Compare.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def compare_params
      params.require(:compare).permit(:name, :offers, :collections)
    end
end
