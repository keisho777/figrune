class FiguresController < ApplicationController
  before_action :authenticate_user!
  def index
    @q = current_user.figures.ransack(params[:q])
    @figures = @q.result(distinct: true).order("created_at desc")
  end
end
