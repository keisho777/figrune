class FiguresController < ApplicationController
  before_action :authenticate_user!

  def index
    @q = current_user.figures.ransack(params[:q])
    @figures = @q.result(distinct: true).order("created_at desc")
  end

  def new
    @figure = Figure.new
  end

  def create
    @figure = current_user.figures.build(figure_params)
    if @figure.save
      redirect_to figures_path, success: t('defaults.flash_message.created')
    else
      # flash.now[:danger] = t('defaults.flash_message.not_created')
      render :new, status: :unprocessable_entity
    end
  end
end
