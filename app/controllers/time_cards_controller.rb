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
    @basic_time = (basic_minute / 60).to_f.floor(2) + basic_hour
    designated_minute = TimeBasicInformation.first.designated_working_times.strftime('%M').to_i
    designated_hour = TimeBasicInformation.first.designated_working_times.strftime('%H').to_i
    @designated_time = (designated_minute / 60).to_f.floor(2) + designated_hour
    #出勤日数を取得
    today = "#{params[:year]}-#{params[:month]}-1"
    @counts = TimeCard.where(user_id: params[:user_id]).where(date: today.in_time_zone.all_month).where.not(out_at: nil).count
    #トータル在社時間を取得
    sum_in_at = TimeCard.where(user_id: params[:user_id]).where(date: today.in_time_zone.all_month).where.not(out_at: nil).sum(:in_at)
    sum_out_at = TimeCard.where(user_id: params[:user_id]).where(date: today.in_time_zone.all_month).where.not(out_at: nil).sum(:out_at)
    if sum_in_at && sum_out_at then
      @sum_time = sum_in_at - sum_out_at
    else
      @sum_time = nil
    end
    #総合勤務時間を取得
    @total_work_time = @counts * @basic_time
    @total_work_time = @total_work_time.floor(2)
    #先月・翌月を取得
    date = Date.new(params[:year].to_i, params[:month].to_i, 1)
    @pre_year = date.last_month.year
    @pre_month = date.last_month.month
    @next_year = date.next_month.year
    @next_month = date.next_month.month
    #合計在社時間を取得
    time_cards = TimeCard.where.not(in_at: nil).where(date: today.in_time_zone.all_month).where.not(out_at: nil)
    @sum_stay_time = 0
    # byebug
    for time_card in time_cards
      stay_time = ((time_card.out_at - time_card.in_at) / 60 / 60).floor(2)
      if time_card.in_at < "09:00" then
        stay_time += 24
      end
      @sum_stay_time += stay_time
    end
    @sum_stay_time = @sum_stay_time.round(2)
  end

  def new
  end

  # GET /time_cards/1/edit
  def edit
    today = Date.current
    @time_cards = TimeCard.where(user_id: params[:user_id]).where(date: today.in_time_zone.all_month)
  end

  # POST /time_cards
  # POST /time_cards.json
  def create
    # byebug
    if params[:button_type] == 'attendance' then
      time_card = TimeCard.find_by(user_id: params[:user_id], date: params[:date_type])
      if time_card == nil then
        time_card = TimeCard.new(
          in_at: Time.now,
          out_at: '',
          date: Date.current,
          user_id: params[:user_id]
        )
      else
        time_card.in_at = Time.now
      end
    else
      time_card = TimeCard.find_by(user_id: params[:user_id], date: params[:date_type])
      time_card.out_at = Time.now
    end

    if time_card.save
      flash[:success] = "出社/退社処理が完了しました。"
      redirect_to action: 'show', user_id: params[:user_id], year: Date.current.year, month: Date.current.month
    else
      flash[:danger] = "出社/退社処理が失敗しました。"
      redirect_to root_url
    end
  end
  
  
  
  

  # PATCH/PUT /time_cards/1
  # PATCH/PUT /time_cards/1.json
  def update
    days = params[:days].to_i
    for day in 1..days do
      time_card = TimeCard.find_by(user_id:params[:id], date:Date.strptime("#{params[:year]}-#{params[:month]}-#{day}", '%Y-%m-%d'))
      # byebug
      #登録済みのレコードなら更新
      if time_card then
        time_card.in_at = "#{params[:"#{day}"][:in_at]}"
        time_card.out_at = params["#{day}"][:out_at]
        # byebug
        time_card.remarks = params["#{day}"][:remarks]
        
      #登録されていないなら新規登録
      else
        time_card = TimeCard.new(
        in_at: "#{params[:"#{day}"][:in_at]}",
        out_at: params["#{day}"][:out_at],
        date: Date.strptime("#{params[:year]}-#{params[:month]}-#{day}"),
        remarks: params["#{day}"][:remarks],
        user_id: params[:id]
        )
      end
      time_card.save
    end
    flash[:success] = "勤怠編集処理が完了しました。"
    redirect_to action: 'show', user_id: params[:id], year: params[:year], month: params[:month]
  end

  def destroy
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
