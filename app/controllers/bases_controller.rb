class BasesController < ApplicationController
  
  before_action :logged_in_user
  before_action :admin_user
  
  def index
    @bases = Base.all
  end
  
  def new
    @base = Base.new  
  end
  
  def create
    @base = Base.new(base_params)    # 実装は終わっていないことに注意!
    if @base.save
      flash[:success] = "拠点情報を追加しました。"
      redirect_to bases_url
    else
      render 'new'
    end
  end
  
  def destroy
    # byebug
    Base.find(params[:id]).destroy
    flash[:success] = "該当の拠点が削除されました。"
    redirect_to bases_url
  end
  
  def edit
    @base = Base.find(params[:id])
  end
  
  def update
    # byebug
    @base = Base.find(params[:id])
    if @base.update_attributes(base_params)
      flash[:success] = "拠点情報が更新されました。"
      redirect_to bases_url
    else
      render 'edit'      
    end
  end
  
  private

    def base_params
      params.require(:base).permit(:base_number, :base_name, :attendance_type)
    end
  
end
