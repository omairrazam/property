class PlotFilesController < ApplicationController
  before_action :set_plot_file, only: [:show, :edit, :update, :destroy]

  # GET /plot_files
  # GET /plot_files.json
  def index
    @plot_files = PlotFile.all
  end

  # GET /plot_files/1
  # GET /plot_files/1.json
  def show
  end

  # GET /plot_files/new
  def new
    @plot_file = PlotFile.new
  end

  # GET /plot_files/1/edit
  def edit
  end

  # POST /plot_files
  # POST /plot_files.json
  def create
    @plot_file = PlotFile.new(plot_file_params)

    respond_to do |format|
      if @plot_file.save
        format.html { redirect_to @plot_file, notice: 'Plot file was successfully created.' }
        format.json { render :show, status: :created, location: @plot_file }
      else
        format.html { render :new }
        format.json { render json: @plot_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /plot_files/1
  # PATCH/PUT /plot_files/1.json
  def update
    respond_to do |format|
      if @plot_file.update(plot_file_params)
        format.html { redirect_to @plot_file, notice: 'Plot file was successfully updated.' }
        format.json { render :show, status: :ok, location: @plot_file }
      else
        format.html { render :edit }
        format.json { render json: @plot_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /plot_files/1
  # DELETE /plot_files/1.json
  def destroy
    @plot_file.destroy
    respond_to do |format|
      format.html { redirect_to plot_files_url, notice: 'Plot file was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plot_file
      @plot_file = PlotFile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def plot_file_params
      params.require(:plot_file).permit(:serial_no, :category_id, :region_id)
    end
end
