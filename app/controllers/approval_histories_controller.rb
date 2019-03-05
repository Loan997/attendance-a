class ApprovalHistoriesController < ApplicationController
  require 'date'
  
  before_action :logged_in_user
  
  def index
    @approval_histories = ApprovalHistory.where(user_id: current_user.id).where(date: Time.current.in_time_zone.all_month).order(:date, {created_at: :desc})
  end
  
  def search
    # byebug
    @approval_histories = ApprovalHistory.where(user_id: current_user.id).where(date: "#{params[:year]}-#{params[:month]}-1".in_time_zone.all_month)
    # byebug
    render json: @approval_histories
  end
end
