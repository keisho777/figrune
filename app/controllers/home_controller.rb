class HomeController < ApplicationController
before_action :authenticate_user!
MAX_MONTHS = 12

def index
  today = Date.current
  @from = params[:from].present? ? Date.strptime(params[:from], "%Y-%m").beginning_of_month : Date.current.beginning_of_month
  @to = params[:to].present? ? Date.strptime(params[:to], "%Y-%m").end_of_month : @from + MAX_MONTHS.months - 1

  @months = (@from.to_date..@to.to_date).select { |d| d.day == 1 }
  chart_data = current_user.figures.where(payment_status: :unpaid)
                           .where(release_month: @from..@to)
                           .group(:release_month)
                           .sum(:total_price)

  @selected_month =
    if params[:selected_month].present?
      Date.strptime(params[:selected_month], "%Y-%m").beginning_of_month
    else
      @from
    end

  @figures =
    if @selected_month
      current_user.figures.where(release_month: @selected_month)
    else
      current_user.figures.where(release_month: @from..@to)
    end
  @unpaid_total = @figures.where(payment_status: :unpaid).sum(:total_price)

  @labels = @months.each_with_index.map do |d, i|
    if i == 0 || d.month == 1
      # [d.strftime("%m月"), d.strftime("%Y年")] # 月（1行目）、年（2行目）
      d.strftime("%m月")
    else
      d.strftime("%m月") # 月だけ（1行）
    end
  end
  @data = @months.map { |d| chart_data[d.beginning_of_month] || 0 }
 end
end
