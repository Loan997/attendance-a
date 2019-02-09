class ApprovalHistoriesController < ApplicationController
  def index
    @approval_histories = ApprovalHistory.where(user_id: current_user.id).where(date: "2019-2-1".in_time_zone.all_month).order(:date, {created_at: :desc})
  end
end
