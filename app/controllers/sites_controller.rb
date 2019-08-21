class SitesController < ApplicationController
  before_action :set_site, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, :except => :public
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  # GET /sites
  # GET /sites.json
  def index
    @sites = Site.all
  end
  def public
    @sites = [{:name=>"Хорошо Нижний Новгород",:address=>"horosho-nn.ru"},{:name=>"Хорошо Уфа",:address=>"horosho-ufa.ru"}]
    respond_to do |format|
      
        format.json { render "public.json" }
    end
    
  end

  # GET /sites/1
  # GET /sites/1.json
  def show
  end

  # GET /sites/new
  def new
    @site = Site.new
  end

  # GET /sites/1/edit
  def edit
  end

  # POST /sites
  # POST /sites.json
  def create
    @site = Site.new(site_params)

    respond_to do |format|
      if @site.save
        format.html { redirect_to @site, notice: 'Site was successfully created.' }
        format.json { render :show, status: :created, location: @site }
      else
        format.html { render :new }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sites/1
  # PATCH/PUT /sites/1.json
  def update
    respond_to do |format|
      if @site.update(site_params)
        format.html { redirect_to @site, notice: 'Site was successfully updated.' }
        format.json { render :show, status: :ok, location: @site }
      else
        format.html { render :edit }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sites/1
  # DELETE /sites/1.json
  def destroy
    @site.destroy
    respond_to do |format|
      format.html { redirect_to sites_url, notice: 'Site was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_site
      @site = Site.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def site_params
      params.require(:site).permit(:name, :model, :url, :site_login, :site_pass,:home_ftp, :soap_login,:soap_url, :soap_pass,
                                  :home_file_name, :home_login, :home_pass, :site_global_parent, :csv_collection_order, 
                                  :csv_variant_order, :site_variant_order, :csv_offer_order, :site_offer_order, :sort_order,
                                  :scu_field, :quantity_field, :title_field, :csv_images_order, :site_collections_order, :csv_collections_order)
    end
end
