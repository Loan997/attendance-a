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
      redirect_to(root_url) unless current_user.admin?
    end
    
    # 正しいユーザーか、もしくは管理者かどうかを確認
    def admin_user_or_correct_user
      @user = User.find(params[:user_id])
      unless @user == current_user
        unless current_user.admin
          redirect_to(root_url)
        end
      end
    end
end