class CollectionsController < ApplicationController
  before_action :set_collection, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, :except => :public
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
  # GET /collections
  # GET /collections.json
  def index
    com_id= params[:compare]
    if com_id 
      @collections = Compare.find(com_id).collections.where(params[:compare]).order(:flat)
    else
      @collections = Collection.all.order(:flat)
    end
  end

  # GET /collections/1
  # GET /collections/1.json
  def show
    
  end

  # GET /collections/new
  def new
     com_id= params[:compare]
    @collection = Collection.new
    @collection.compare_id =com_id
  end

  # GET /collections/1/edit
  def edit
  end

  # POST /collections
  # POST /collections.json
  def create
    c= Compare.find(params[:compare])
    c.collections << Collection.new(collection_params)
    @collection = c.collections.last

    respond_to do |format|
      if @collection.save
        format.html { redirect_to [@collection.compare.site,@collection], notice: 'Collection was successfully created.' }
        format.json { render :show, status: :created, location: @collection }
      else
        format.html { render :new }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /collections/1
  # PATCH/PUT /collections/1.json
  def update
    respond_to do |format|
      if @collection.update(collection_params)
        format.html { redirect_to [@collection.compare.site,@collection], notice: 'Collection was successfully updated.' }
        format.json { render :show, status: :ok, location: @collection }
      else
        format.html { render :edit }
        format.json { render json: @collection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collections/1
  # DELETE /collections/1.json
  def destroy
    @collection.destroy
    respond_to do |format|
      format.html { redirect_to site_collections_url, notice: 'Collection was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collection
      @collection = Collection.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def collection_params
      params.fetch(:collection, {}).permit(:name,:flat)
    end
end
