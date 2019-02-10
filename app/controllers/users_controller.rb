class UsersController < ApplicationController
  
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy, :index]

  def index
    @users = User.paginate(page: params[:page])
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
      flash[:success] = "アカウント情報が更新されました。"
      if current_user.admin?
        redirect_to action: 'index'
      else
        redirect_to controller: 'time_cards', action: 'show', user_id: @user.id, year: Date.current.year, month: Date.current.month
      end
    else
      render 'index'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "該当ユーザーが削除されました。"
    redirect_to users_url
  end
  
  #出勤中の社員一覧ページの表示
  def in_attendance
    @time_cards = TimeCard.where(date: Date.current).where.not(in_at: nil).where(out_at: nil)
  end
  
  #ユーザーのCSVインポート
  def import 
    import_users(params[:file])
    redirect_to users_url, notice: "#{registered_count}件登録しました。"
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :affiliation, :password,
                                   :password_confirmation, :employee_number, :uid, :basic_time, :designated_working_start_time, :designated_working_end_time)
    end
    
    # beforeフィルター

    # 正しいユーザーかどうかを確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    #csvのインポート処理
    def import_users(file)
      # byebug
      # 登録処理前のレコード数
      # current_email_count = ::Email.count
      # emails = []
      # windowsで作られたファイルに対応するので、encoding: "SJIS"を付けている
      
      CSV.foreach(params[:file].path, headers: true, encoding: 'UTF-8') do |row|
        
        row.str.encode("UTF-16BE", "UTF-8",
           invalid: :replace,
           undef: :replace,
           replace: '.').encode("UTF-8")
        
        
        
        
        
        user = User.new
        user.attributes = row.to_hash.slice(csv_attributes)
        user.save!
        # emails << ::Email.new({ name: row["name"], email: row["email"] })
      end
      # importメソッドでバルクインサートできる
      # ::Email.import(emails)
      # 何レコード登録できたかを返す
      # ::Email.count - current_email_count
    end

end