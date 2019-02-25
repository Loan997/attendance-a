class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

    # ユーザーのログインを確認する
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end
    
    # 管理者かどうかを確認
    def admin_user
      unless current_user.admin?
        flash[:danger] = "管理者以外はアクセスできません。"
        redirect_to controller: 'time_cards', action: 'show', user_id: current_user.id, year: Date.current.year, month: Date.current.month
      end
    end
    
    # 正しいユーザーか、もしくは管理者かどうかを確認
    # byebug
    def admin_user_or_correct_user
      @user = User.find(params[:user_id]?params[:user_id]:params[:id])
      unless @user == current_user
        unless current_user.admin
          flash[:danger] = "他ユーザーのページへは、アクセスできません。"
          redirect_to action: 'show', user_id: current_user.id, year: Date.current.year, month: Date.current.month
        end
      end
    end
end