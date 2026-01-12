class FiguresController < ApplicationController
  before_action :authenticate_user!
  def index
    @q = Figure.ransack(params[:q])
    @figures = @q.result(distinct: true).includes(:user).order("created_at desc")
  end
end
