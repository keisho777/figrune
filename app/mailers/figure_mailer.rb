class FigureMailer < ApplicationMailer
  def monthly_payment_summary(user, figures, release_month, unpaid_total_price)
    @user = user
    @figures = figures
    @month_date = release_month
    @unpaid_total_price = unpaid_total_price

    mail(
      to: user.email,
      subject: "【Figrune】#{release_month.strftime('%Y年%-m月')}発売予定のフィギュア"
    )
  end
end
