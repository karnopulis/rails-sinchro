class CollectImportsController < ApplicationController
  before_action :set_collect_import, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, :except => :public
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
  # GET /collect_imports
  # GET /collect_imports.json
  def index
    com_id= params[:compare]
    if com_id 
      @collect_imports = Compare.find(com_id).collect_imports.where(params[:compare])
      @collection_imports = Kaminari.paginate_array(@collect_imports.pluck("flat").uniq.sort!).page(params[:page]).per(50)
    else
      @collect_imports = CollectImport.all
      @collection_imports =Kaminari.paginate_array( @collect_imports.pluck("flat").uniq.sort!).page(params[:page]).per(50)
    end

  end

  # GET /collect_imports/1
  # GET /collect_imports/1.json
  def show
    @collects =Compare.find(@collect_import.compare_id).collect_imports.where(:flat=> @collect_import.flat).order(:scu)
  end

  # GET /collect_imports/new
  def new
    @collect_import = CollectImport.new
  end

  # GET /collect_imports/1/edit
  def edit
  end

  # POST /collect_imports
  # POST /collect_imports.json
  def create
    @collect_import = CollectImport.new(collect_import_params)

    respond_to do |format|
      if @collect_import.save
        format.html { redirect_to @collect_import, notice: 'Collect import was successfully created.' }
        format.json { render :show, status: :created, location: @collect_import }
      else
        format.html { render :new }
        format.json { render json: @collect_import.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /collect_imports/1
  # PATCH/PUT /collect_imports/1.json
  def update
    respond_to do |format|
      if @collect_import.update(collect_import_params)
        format.html { redirect_to @collect_import, notice: 'Collect import was successfully updated.' }
        format.json { render :show, status: :ok, location: @collect_import }
      else
        format.html { render :edit }
        format.json { render json: @collect_import.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collect_imports/1
  # DELETE /collect_imports/1.json
  def destroy
    @collect_import.destroy
    respond_to do |format|
      format.html { redirect_to collect_imports_url, notice: 'Collect import was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collect_import
      @collect_import = CollectImport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def collect_import_params
      params.fetch(:collect_import, {})
    end
end
