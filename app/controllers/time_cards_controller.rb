class TimeCardsController < ApplicationController
  
  require 'date'
  # require 'mathn'
  
  before_action :logged_in_user, only: [:show, :edit, :update]
  before_action :admin_user_or_correct_user, only: [:show, :edit]
  # before_action :logged_in_user, only: [:edit, :update]

  def index
  end

  def show
    #氏名・所属を取得するためのインスタンス
    user_id = params[:user_id]?params[:user_id]:params[:id]
    @user = User.find(user_id)
    
    # #基本情報を取得
    # get_basic_information
    # byebug
    #出勤日数を取得
    today = "#{params[:year]}-#{params[:month]}-1"
    @counts = TimeCard.where(user_id: params[:user_id]).where(date: today.in_time_zone.all_month).where.not(out_at: nil).count
    
    # #総合勤務時間を取得
    # # byebug
    # @total_work_time = @counts * @basic_time
    # @total_work_time = @total_work_time.floor(2)
    
    #先月・翌月を取得
    get_previous_and_next_month
    
    #合計在社時間を取得
    get_sum_stay_time(@user)
    
    (1..view_context.get_days).each do |day|
      TimeCard.find_or_create_by!(user_id: params[:user_id], date: "#{params[:year]}-#{params[:month]}-#{day}")
    end
    
    
  end

  def new
  end

  # GET /time_cards/1/edit
  def edit
    (1..view_context.get_days).each do |day|
      TimeCard.find_or_create_by!(user_id: params[:user_id], date: "#{params[:year]}-#{params[:month]}-#{day}")
    end
    @time_cards = TimeCard.where(user_id: params[:user_id]).where(date: "#{params[:year]}-#{params[:month]}-1".in_time_zone.all_month).order("date")
  end
  
  # 残業申請フォーム
  def apply
    @time_card = TimeCard.find_by(user_id:current_user.id, date:"#{params[:year]}-#{params[:month]}-#{params[:day]}")
    @supervisors = User.where(superior: 1)
    # byebug
    # byebug
    # @user = User.find(current_user.id)
    # render 'apply'
    
  end
  
  #勤怠申請の承認フォーム
  def approval_attendance
    # byebug
    @time_cards = TimeCard.where(is_attendance_application_for_a_month: 1)
                    .or(TimeCard.where(is_attendance_application_for_a_month: 2))
                    .where(application_targer_for_a_month: current_user.id)
                    .order("user_id", "date")
    
    @supervisors = User.where(superior: 1)
  end
  
  #残業申請の承認フォーム
  def approval_overtime_working
    # byebug
    @time_cards = TimeCard.where(is_overtime_applying: 1)
                    .or(TimeCard.where(is_overtime_applying: 2))
                    .where(overtime_application_target: current_user.id)
                    .order("user_id", "date")
                    
    @supervisors = User.where(superior: 1)
  end
  
  #勤怠変更の承認フォーム
  def approval_attendance_change
    @time_cards = TimeCard.where(is_applying_attendance_change: 1)
                    .or(TimeCard.where(is_applying_attendance_change: 2))
                    .where(applying_attendance_change_target: current_user.id)
                    .order("user_id", "date")
                    
    @supervisors = User.where(superior: 1)
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
  
  #勤怠更新
  def update
    # 変更申請になった時の時刻を覚えておいて。そのタイミングの時刻をバッファとして覚えておけば、変更前の時間も取得できるかも？
    @time_cards = TimeCard.where(id: time_cards_params.keys).order('date')
    # byebug
    ActiveRecord::Base.transaction do
      # byebug
      @time_cards.each do |time_card|
        # byebug
        time_card.previous_in_at = time_card.in_at
        time_card.previous_out_at = time_card.out_at
      
        time_card.attributes = time_cards_params["#{time_card.id}"]
      
        if params[:time_cards]["#{time_card.id}"][:applying_attendance_change_target] != "" && params[:time_cards]["#{time_card.id}"][:applying_attendance_change_target].present?
          time_card.applying_attendance_change_target = User.find(params[:time_cards]["#{time_card.id}"][:applying_attendance_change_target])
          time_card.is_applying_attendance_change = ApplyingState.find(2)
          
          
          
          # 変更申請になった時の時刻を覚えておいて。そのタイミングの時刻をバッファとして覚えておけば、変更前の時間も取得できるかも？
          
          
          
        end
        
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
  
  # 勤怠申請、残業申請
  def apply_update
    # 勤怠申請の場合
    if params[:type] == "for_a_month_application"
      @time_card = TimeCard.find_by(user_id: current_user.id, date:Date.strptime("#{params[:year]}-#{params[:month]}-1", '%Y-%m-%d'))
      # byebug
      @time_card.update!(is_attendance_application_for_a_month: ApplyingState.find_by(status: "申請中"),
                        application_targer_for_a_month: params[:test].present? ? User.find(params[:test]) : nil)
      flash[:success] = "勤怠申請が完了しました。"
      redirect_to controller: 'time_cards', action: 'show', user_id: current_user.id, year: Date.current.year, month: Date.current.month
    # 残業申請の場合
    elsif params[:time_card][:type] == "overtime_application"
      @time_card = TimeCard.find(params[:time_card][:id])
      # byebug
      if @time_card.update_attributes(time_card_params)
        # byebugs
        @time_card.overtime_application_target =params[:time_card][:test].present? ? User.find(params[:time_card][:test]) : nil
        @time_card.is_overtime_applying = ApplyingState.find_by(status: "申請中")
        # if params[:next_day].nil?
        #   @time_card.end_estimated_time = @time_card.end_estimated_time - 24
        # end
        @time_card.save!
        flash[:success] = "残業申請が完了しました。"
        redirect_to controller: 'time_cards', action: 'show', user_id: current_user.id, year: Date.current.year, month: Date.current.month
      else
        render 'edit'
      end
    # # 勤怠申請の場合
    # elsif params[:type] == "for_a_month_application"
    #   @time_card = TimeCard.find_by(user_id: current_user.id, date:Date.strptime("#{params[:year]}-#{params[:month]}-1", '%Y-%m-%d'))
    #   @time_card.update(is_attendance_application_for_a_month: ApplyingState.find_by(status: "申請中"),
    #                     application_targer_for_a_month: User.find(params[:test]))
    #   @time_card.save!
    #   flash[:success] = "勤怠申請が完了しました。"
    #   redirect_to controller: 'time_cards', action: 'show', user_id: current_user.id, year: Date.current.year, month: Date.current.month
    # end
    end
  end
  
  #１ヶ月分の勤怠申請の承認フォームから更新
  def approval_attendance_update
    @time_cards = TimeCard.where(id: time_cards_params.keys).order('date')
    count_change = 0
    @time_cards.each do |time_card|
      # byebug
      if params[:time_cards]["#{time_card.id}"][:change]
        time_card.is_attendance_application_for_a_month = params[:time_cards]["#{time_card.id}"][:is_attendance_application_for_a_month].present? ? ApplyingState.find(params[:time_cards]["#{time_card.id}"][:is_attendance_application_for_a_month]) : nil
        time_card.save!
        count_change += 1
      end
    end
    flash[:success] = "#{@time_cards.count}件中#{count_change}件、勤怠申請を更新しました。"
        redirect_to controller: 'time_cards', action: 'show', user_id: current_user.id, year: Date.current.year, month: Date.current.month
  end
  
  #残業申請の承認フォームから更新
  def approval_overtime_working_update
    @time_cards = TimeCard.where(id: time_cards_params.keys).order('date')
    count_change = 0
    @time_cards.each do |time_card|
      # byebug
      if params[:time_cards]["#{time_card.id}"][:change]
        time_card.is_overtime_applying = ApplyingState.find(params[:time_cards]["#{time_card.id}"][:is_attendance_application_for_a_month])
        time_card.save!
        count_change += 1
      end
    end
    flash[:success] = "#{@time_cards.count}件中#{count_change}件、残業申請を更新しました。"
        redirect_to controller: 'time_cards', action: 'show', user_id: current_user.id, year: Date.current.year, month: Date.current.month
  end
  
  #勤怠変更の承認フォームからの更新
  def approval_attendance_change_update
    @time_cards = TimeCard.where(id: time_cards_params.keys).order('date')
    count_change = 0
    @time_cards.each do |time_card|
      # byebug
      if params[:time_cards]["#{time_card.id}"][:change]
        time_card.is_applying_attendance_change = params[:time_cards]["#{time_card.id}"][:is_applying_attendance_change].present? ? ApplyingState.find(params[:time_cards]["#{time_card.id}"][:is_applying_attendance_change]) : nil
        time_card.save!
        count_change += 1
        if time_card.is_applying_attendance_change.id == 3 && time_card.applying_attendance_change_target.present?
          ApprovalHistory.create(
                            user_id: time_card.user_id,
                            in_at: time_card.in_at,
                            out_at: time_card.out_at,
                            date: time_card.date,
                            applying_attendance_change_target: time_card.applying_attendance_change_target,
                            previous_in_at: time_card.previous_in_at,
                            previous_out_at: time_card.previous_out_at
                            )
        end
      end
    end
    flash[:success] = "#{@time_cards.count}件中#{count_change}件、勤怠変更申請を更新しました。"
        redirect_to controller: 'time_cards', action: 'show', user_id: current_user.id, year: Date.current.year, month: Date.current.month
  end
  

  def destroy
  end
  
  #勤怠確認画面の表示
  def confirm
    #氏名・所属を取得するためのインスタンス
    @user = User.find(params[:user_id])
    
    # #基本情報を取得
    # get_basic_information
    # byebug
    #出勤日数を取得
    today = "#{params[:year]}-#{params[:month]}-1"
    @counts = TimeCard.where(user_id: params[:user_id]).where(date: today.in_time_zone.all_month).where.not(out_at: nil).count
    
    # #総合勤務時間を取得
    # # byebug
    # @total_work_time = @counts * @basic_time
    # @total_work_time = @total_work_time.floor(2)
    
    #先月・翌月を取得
    # get_previous_and_next_month
    
    #合計在社時間を取得
    get_sum_stay_time(@user)
    
    # (1..view_context.get_days).each do |day|
    #   TimeCard.find_or_create_by!(user_id: params[:user_id], date: "#{params[:year]}-#{params[:month]}-#{day}")
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_card
      @time_card = TimeCard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def time_cards_params
      # params.require(:time_cards).permit(:in_at, :out_at, :date, :user_id, :id)
      params.permit(:utf8, :_method, :authenticity_token, :days, :year, :month, :commit, :id, 
                    time_cards: [:id, :in_at, :out_at, :date, :user_id, :remarks, :end_estimated_time, :business_outline, :is_overtime_applying, 
                    :overtime_application_target, :is_attendance_application_for_a_month, :application_targer_for_a_month, 
                    :is_applying_attendance_change, :is_leaving_next_day])[:time_cards]
    end
    
    def time_card_params
      # params.require(:time_cards).permit(:in_at, :out_at, :date, :user_id, :id)
      params.permit(:utf8, :_method, :authenticity_token, :days, :year, :month, :commit, :id, 
                    time_card: [:id, :in_at, :out_at, :date, :user_id, :remarks, :end_estimated_time, :business_outline, :is_overtime_applying, 
                    :overtime_application_target, :is_attendance_application_for_a_month, :application_targer_for_a_month, 
                     :applying_attendance_change_target, :next_day])[:time_card]
    end
    
    # #基本情報を取得
    # def get_basic_information
    #   basic_minute = TimeBasicInformation.first.basic_time.strftime('%M').to_i
    #   basic_hour = TimeBasicInformation.first.basic_time.strftime('%H').to_i
    #   @basic_time = (basic_minute / 60).to_f.floor(2) + basic_hour
    #   designated_minute = TimeBasicInformation.first.designated_working_times.strftime('%M').to_i
    #   designated_hour = TimeBasicInformation.first.designated_working_times.strftime('%H').to_i
    #   @designated_time = (designated_minute / 60).to_f.floor(2) + designated_hour
    # end
    
    
    #先月・翌月を取得
    def get_previous_and_next_month
      date = Date.new(params[:year].to_i, params[:month].to_i, 1)
      @pre_year = date.last_month.year
      @pre_month = date.last_month.month
      @next_year = date.next_month.year
      @next_month = date.next_month.month
    end
    
    #合計在社時間を取得
    def get_sum_stay_time(user)
      today = "#{params[:year]}-#{params[:month]}-1"
      time_cards = TimeCard.where(user_id: user.id).where.not(in_at: nil).where(date: today.in_time_zone.all_month).where.not(out_at: nil)
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

