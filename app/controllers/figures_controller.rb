class FiguresController < ApplicationController
  before_action :authenticate_user!

  def index
    @q = current_user.figures.ransack(params[:q])
    @figures = @q.result(distinct: true).order("created_at desc")
  end

  def new
    @figure = Figure.new
    # 初期値設定のため
    @figure.quantity = 1
  end

  def create
     @figure = current_user.figures.build(figure_params)
     # 以下3点のassign_テーブル名_by_nameについて
     # フォームで入力された名称をもとに、各関連モデルを取得（なければ作成）して Figure に紐付ける
     @figure.assign_work_by_name(@figure.work_name)
     @figure.assign_shop_by_name(@figure.shop_name)
     @figure.assign_manufacture_by_name(@figure.manufacture_name)
    if @figure.save
      redirect_to figures_path, notice: t("defaults.flash_message.created")
    else
      flash.now[:alert] = t("defaults.flash_message.not_created")
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @figure = Figure.find(params[:id])
  end

  private

  def figure_params
    params.require(:figure).permit(:name, :release_month, :quantity, :price, :payment_status, :size_type, :size_mm, :work_name, :shop_name, :manufacture_name, :note)
  end
end
