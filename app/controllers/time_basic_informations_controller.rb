class TimeBasicInformationsController < ApplicationController
  before_action :set_time_basic_information, only: [:show, :edit, :update, :destroy]

  # GET /time_basic_informations
  # GET /time_basic_informations.json
  def index
    @time_basic_informations = TimeBasicInformation.all
  end

  # GET /time_basic_informations/1
  # GET /time_basic_informations/1.json
  def show
  end

  # GET /time_basic_informations/new
  def new
    @time_basic_information = TimeBasicInformation.new
  end

  # GET /time_basic_informations/1/edit
  def edit
  end

  # POST /time_basic_informations
  # POST /time_basic_informations.json
  def create
    @time_basic_information = TimeBasicInformation.new(time_basic_information_params)

    respond_to do |format|
      if @time_basic_information.save
        format.html { redirect_to @time_basic_information, notice: 'Time basic information was successfully created.' }
        format.json { render :show, status: :created, location: @time_basic_information }
      else
        format.html { render :new }
        format.json { render json: @time_basic_information.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /time_basic_informations/1
  # PATCH/PUT /time_basic_informations/1.json
  def update
    respond_to do |format|
      if @time_basic_information.update(time_basic_information_params)
        format.html { redirect_to @time_basic_information, notice: 'Time basic information was successfully updated.' }
        format.json { render :show, status: :ok, location: @time_basic_information }
      else
        format.html { render :edit }
        format.json { render json: @time_basic_information.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_basic_informations/1
  # DELETE /time_basic_informations/1.json
  def destroy
    @time_basic_information.destroy
    respond_to do |format|
      format.html { redirect_to time_basic_informations_url, notice: 'Time basic information was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_basic_information
      @time_basic_information = TimeBasicInformation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def time_basic_information_params
      params.require(:time_basic_information).permit(:designated_working_times, :basic_time)
    end
end
