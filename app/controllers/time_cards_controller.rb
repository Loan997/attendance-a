class TimeCardsController < ApplicationController
  
  require 'date'
  
  # before_action :set_time_card, only: [:show, :edit, :update, :destroy]

  def index
  end

  # GET /time_cards/1
  # GET /time_cards/1.json
  def show
    # @days = get_days(params[:year], params[:month])
    user_id = params[:user_id]
    @user = User.find(user_id)
  end

  def new
  end

  # GET /time_cards/1/edit
  def edit
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
