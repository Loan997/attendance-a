class TimeCardsController < ApplicationController
  
  require 'date'
  require 'mathn'
  
  # before_action :set_time_card, only: [:show, :edit, :update, :destroy]

  def index
  end

  # GET /time_cards/1
  def show
    #氏名・所属を取得するためのインスタンス
    user_id = params[:user_id]
    @user = User.find(user_id)
    #基本情報を取得
    basic_minute = TimeBasicInformation.first.basic_time.strftime('%M').to_i
    basic_hour = TimeBasicInformation.first.basic_time.strftime('%H').to_i
    @basic_time = (basic_minute / 60).to_f.round(2) + basic_hour
    designated_minute = TimeBasicInformation.first.designated_working_times.strftime('%M').to_i
    designated_hour = TimeBasicInformation.first.designated_working_times.strftime('%H').to_i
    @designated_time = (designated_minute / 60).to_f.round(2) + designated_hour
    #出勤日数を取得
    today = Date.today
    @counts = TimeCard.where(user_id: params[:user_id]).where(date: today.in_time_zone.all_month).where.not(out_at: nil).count
    #トータル在社時間を取得
    sum_in_at = TimeCard.where(user_id: params[:user_id]).where(date: today.in_time_zone.all_month).where.not(out_at: nil).sum(:in_at)
    sum_out_at = TimeCard.where(user_id: params[:user_id]).where(date: today.in_time_zone.all_month).where.not(out_at: nil).sum(:out_at)
    @sum_time = sum_in_at - sum_out_at
    #総合勤務時間を取得
    @total_work_time = @counts * @basic_time
    #先月・翌月を取得
    date = Date.new(params[:year].to_i, params[:month].to_i, 1)
    @pre_year = date.last_month.year
    @pre_month = date.last_month.month
    @next_year = date.next_month.year
    @next_month = date.next_month.month
  end

  def new
  end

  # GET /time_cards/1/edit
  def edit
    today = Date.today
    @time_cards = TimeCard.where(user_id: params[:user_id]).where(date: today.in_time_zone.all_month)
  end

  # POST /time_cards
  # POST /time_cards.json
  def create
    if params[:button_type] == 'attendance' then
      time_card = TimeCard.new(
        in_at: Time.now,
        out_at: '',
        date: Date.today,
        user_id: params[:user_id]
        )
    else
      time_card = TimeCard.find_by(user_id: params[:user_id], date: params[:date_type])
      time_card.out_at = Time.now
    end

    if time_card.save
      flash[:info] = "出社/退社処理が完了しました。"
      redirect_to action: 'show', user_id: params[:user_id], year: Date.today.year, month: Date.today.month
    else
      flash[:info] = "出社/退社処理が失敗しました。"
      redirect_to root_url
    end
  end

  # PATCH/PUT /time_cards/1
  # PATCH/PUT /time_cards/1.json
  def update
    respond_to do |format|
      if @time_card.update(time_card_params)
        format.html { redirect_to @time_card, notice: 'Time card was successfully updated.' }
        format.json { render :show, status: :ok, location: @time_card }
      else
        format.html { render :edit }
        format.json { render json: @time_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_cards/1
  # DELETE /time_cards/1.json
  def destroy
    @time_card.destroy
    respond_to do |format|
      format.html { redirect_to time_cards_url, notice: 'Time card was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_card
      @time_card = TimeCard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def time_card_params
      params.require(:time_card).permit(:in_at, :out_at, :date, :user_id)
    end
end
