class FiguresController < ApplicationController
  before_action :authenticate_user!

  def index
    @q = current_user.figures.ransack(params[:q])
    @figures = @q.result(distinct: true).order("created_at desc").page(params[:page])
  end

  def new
    @figure = Figure.new
    # 初期値設定のため
    @figure.quantity = 1
  end

  def create
     @figure = current_user.figures.build(figure_params)
     @figure.calculate_total_price
     # 以下3点のassign_テーブル名_by_nameについて
     # フォームで入力された名称をもとに、各関連モデルを取得（なければ作成）して Figure に紐付ける
     @figure.assign_work_by_name(@figure.work_name)
     @figure.assign_shop_by_name(@figure.shop_name)
     @figure.assign_manufacturer_by_name(@figure.manufacturer_name)
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

  def edit
    @figure = current_user.figures.find(params[:id])
    # 以下3点の　set_仮想カラム名_from_テーブル名　について
    # 編集画面を表示するとき、外部キーが設定されていれば、関連先テーブルのnameを取得して
    # 仮想カラムにセットする
    @figure.set_work_name_from_work
    @figure.set_shop_name_from_shop
    @figure.set_manufacturer_name_from_manufacturer
  end

  def update
    @figure = current_user.figures.find(params[:id])
    @figure.assign_attributes(figure_params)
    @figure.calculate_total_price
    # 以下3点のassign_テーブル名_by_nameについて
    # フォームで入力された名称をもとに、各関連モデルを取得（なければ作成）して Figure に紐付ける
    @figure.assign_work_by_name(@figure.work_name)
    @figure.assign_shop_by_name(@figure.shop_name)
    @figure.assign_manufacturer_by_name(@figure.manufacturer_name)
    if @figure.save
      redirect_to figure_path(@figure), notice: t("defaults.flash_message.updated")
    else
      flash.now[:alert] = t("defaults.flash_message.not_updated")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    figure = current_user.figures.find(params[:id])
    figure.destroy!
    redirect_to figures_path, notice: t("defaults.flash_message.deleted"), status: :see_other
  end

  def autocomplete
    @figures = current_user.figures.select(:name).distinct.where("name like ?", "%#{params[:q]}%")
    respond_to do |format|
      format.js
    end
  end

  def autocomplete_work
    @works = Work.joins(:figures).where(figures: { user_id: current_user.id }).where("works.name LIKE ?", "%#{params[:q]}%").distinct
    respond_to do |format|
      format.js
    end
  end

  def autocomplete_shop
    @shops = Shop.joins(:figures).where(figures: { user_id: current_user.id }).where("shops.name LIKE ?", "%#{params[:q]}%").distinct
    respond_to do |format|
      format.js
    end
  end

  def autocomplete_manufacturer
    @manufacturers = Manufacturer.joins(:figures).where(figures: { user_id: current_user.id }).where("manufacturers.name LIKE ?", "%#{params[:q]}%").distinct
    respond_to do |format|
      format.js
    end
  end

  private

  def figure_params
    params.require(:figure).permit(:name, :release_month, :quantity, :price, :payment_status, :size_type, :size_mm, :work_name, :shop_name, :manufacturer_name, :note)
  end
end
