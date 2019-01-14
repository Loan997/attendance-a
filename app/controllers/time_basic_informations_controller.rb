class TimeBasicInformationsController < ApplicationController
  before_action :set_time_basic_information, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:edit, :update]
  before_action :admin_user, only: [:edit, :update]
  

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
    if @time_basic_information.update(time_basic_information_params)
      flash[:success] = "基本情報が更新されました。"
      redirect_to controller: 'time_cards', action: 'show', user_id: current_user.id, year: Date.current.year, month: Date.current.month
    else
      flash[:danger] = "基本情報の更新が失敗しました。"
      redirect_to controller: 'time_cards', action: 'show', user_id: current_user.id, year: Date.current.year, month: Date.current.month
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
