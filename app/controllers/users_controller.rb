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
    registered_count = import_users(params[:file])
    flash[:success] = "#{registered_count}件登録しました。"
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :affiliation, :password,
                                   :password_confirmation, :employee_number, :uid, :basic_time, :designated_working_start_time, :designated_working_end_time)
    end
    
    def csv_attributes
      ["name", "email", "affiliation","employee_number", "uid", "basic_time", "designated_working_start_time", "designated_working_end_time",
                                    "superior", "admin", "password"]
    end
    
    # def rename_key(old:, new:)
    #   return unless has_key?(old)
    #   return if has_key?(new)
    #   self[new] = self.delete(old)
    # end
    
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
      registered_count = 0
      
      CSV.foreach(params[:file].path, headers: true, encoding: 'Shift_JIS:UTF-8') do |row|
        # byebug
        line = row.to_hash
        user = User.new
        if line.has_key?("basic_work_time")
          line.store("basic_time", row.to_hash["basic_work_time"])
          line.delete("basic_work_time")
        end
        if line.has_key?("designated_work_start_time")
          line.store("designated_working_start_time", row.to_hash["designated_work_start_time"])
          line.delete("designated_work_start_time")
        end
        if line.has_key?("designated_work_end_time")
          line.store("designated_working_end_time", row.to_hash["designated_work_end_time"])
          line.delete("designated_work_end_time")
        end
        # byebug
        # row.to_hash.rename_key(old: :basic_work_time, new: :basic_time)
        user.attributes = line
        user.save!
        registered_count += 1
        # emails << ::Email.new({ name: row["name"], email: row["email"] })
      end
      # importメソッドでバルクインサートできる
      # ::Email.import(emails)
      # 何レコード登録できたかを返す
      # ::Email.count - current_email_count
      return registered_count
    end

end