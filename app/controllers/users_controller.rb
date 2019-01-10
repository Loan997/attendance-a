class UsersController < ApplicationController
  
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    # @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "アカウント作成が完了しました。"
      redirect_to controller: 'time_cards', action: 'show', user_id: @user.id, year: Date.current.year, month: Date.current.month
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      # byebug
      flash[:success] = "アカウント情報が更新されました。"
      redirect_to controller: 'time_cards', action: 'show', user_id: @user.id, year: Date.current.year, month: Date.current.month
    else
      flash[:danger] = "アカウント情報の更新に失敗しました。"
      redirect_to controller: 'time_cards', action: 'show', user_id: @user.id, year: Date.current.year, month: Date.current.month
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "該当ユーザーが削除されました。"
    redirect_to users_url
  end
  
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :affiliation, :password,
                                   :password_confirmation)
    end
    
    # beforeフィルター

    # 正しいユーザーかどうかを確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    # 管理者かどうかを確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end