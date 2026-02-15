class FigureMailer < ApplicationMailer
  def monthly_payment_summary(user, figures, release_month, unpaid_total_price)
    @user = user
    @figures = figures
    @month_date = release_month
    @unpaid_total_price = unpaid_total_price

    mail(
      to: user.email,
      subject: "【Figrune】#{release_month.strftime('%Y年%-m月')}の発売予定フィギュア"
    )
  end
end
