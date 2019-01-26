class TimeCardsController < ApplicationController
  
  require 'date'
  require 'mathn'
  
  before_action :logged_in_user, only: [:show, :edit, :update]
  before_action :admin_user_or_correct_user, only: [:show, :edit]
  # before_action :logged_in_user, only: [:edit, :update]

  def index
  end

  # GET /time_cards/1
  def show
    #氏名・所属を取得するためのインスタンス
    user_id = params[:user_id]?params[:user_id]:params[:id]
    @user = User.find(user_id)
    
    #基本情報を取得
    get_basic_information
    
    #出勤日数を取得
    today = "#{params[:year]}-#{params[:month]}-1"
    @counts = TimeCard.where(user_id: params[:user_id]).where(date: today.in_time_zone.all_month).where.not(out_at: nil).count
    
    #総合勤務時間を取得
    # byebug
    @total_work_time = @counts * @basic_time
    @total_work_time = @total_work_time.floor(2)
    
    #先月・翌月を取得
    get_previous_and_next_month
    
    #合計在社時間を取得
    get_sum_stay_time
    
  end

  def new
  end

  # GET /time_cards/1/edit
  def edit
    today = Date.current
    
    (1..view_context.get_days).each do |day|
      TimeCard.find_or_create_by(user_id: params[:user_id], date: "#{params[:year]}-#{params[:month]}-#{day}")
    end
    @time_cards = TimeCard.where(user_id: params[:user_id]).where(date: today.in_time_zone.all_month).order("date")
  end

  # POST /time_cards
  # POST /time_cards.json
  def create
    if params[:button_type] == 'attendance' then
      time_card = TimeCard.find_by(user_id: params[:user_id], date: params[:date_type])
      if time_card == nil then
        time_card = TimeCard.new(
          in_at: Time.current.strftime('%H:%M:00'),
          out_at: '',
          date: Date.current,
          user_id: params[:user_id]
        )
      else
        time_card.in_at = Time.current.strftime('%H:%M:00')
      end
    else
      time_card = TimeCard.find_by(user_id: params[:user_id], date: params[:date_type])
      time_card.out_at = Time.current.yesterday.strftime('%H:%M:00')
    end

    if time_card.save then
      flash[:success] = "出社/退社処理が完了しました。"
      redirect_to action: 'show', user_id: params[:user_id], year: Date.current.year, month: Date.current.month
    else
      flash[:danger] = "出社/退社処理が失敗しました。"
      redirect_to root_url
    end
  end
  
  def update
    @time_cards = TimeCard.where(id: time_card_params.keys).order('date')
    ActiveRecord::Base.transaction do
      @time_cards.each do |time_card|
        time_card.attributes = time_card_params["#{time_card.id}"]
        unless time_card.save(context: :edit)
          @is_error = true
        end
      end
      # バリデーション に引っかかったレコードがあれば、例外を発生させてロールバックさせる。
      if @is_error == true then
        raise
      end
    end
      flash[:success] = "勤怠編集処理が完了しました。"
      redirect_to action: 'show', user_id: params[:id], year: params[:year], month: params[:month]
    rescue => e
      render action: :edit
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
      # params.require(:time_cards).permit(:in_at, :out_at, :date, :user_id, :id)
      params.permit(:utf8, :_method, :authenticity_token, :days, :year, :month, :commit, :id, time_cards: [:in_at, :out_at, :date, :user_id, :remarks])[:time_cards]
    end
    
    #基本情報を取得
    def get_basic_information
      basic_minute = TimeBasicInformation.first.basic_time.strftime('%M').to_i
      basic_hour = TimeBasicInformation.first.basic_time.strftime('%H').to_i
      @basic_time = (basic_minute / 60).to_f.floor(2) + basic_hour
      designated_minute = TimeBasicInformation.first.designated_working_times.strftime('%M').to_i
      designated_hour = TimeBasicInformation.first.designated_working_times.strftime('%H').to_i
      @designated_time = (designated_minute / 60).to_f.floor(2) + designated_hour
    end
    
    #先月・翌月を取得
    def get_previous_and_next_month
      date = Date.new(params[:year].to_i, params[:month].to_i, 1)
      @pre_year = date.last_month.year
      @pre_month = date.last_month.month
      @next_year = date.next_month.year
      @next_month = date.next_month.month
    end
    
    #合計在社時間を取得
    def get_sum_stay_time
      today = "#{params[:year]}-#{params[:month]}-1"
      time_cards = TimeCard.where.not(in_at: nil).where(date: today.in_time_zone.all_month).where.not(out_at: nil)
      @sum_stay_time = 0
      for time_card in time_cards
        stay_time = ((time_card.out_at - time_card.in_at) / 60 / 60).floor(2)
        if time_card.in_at > time_card.out_at then
          stay_time += 24
        end
        @sum_stay_time += stay_time
      end
    end
    
end

