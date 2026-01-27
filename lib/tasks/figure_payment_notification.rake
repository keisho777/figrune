namespace :reminders do
  desc "フィギュアの月別支払い合計額をメール通知"
  task figure_payment_notification: :environment do
    today = Date.current

    User.includes(:figures).find_each do |user|
      # 今月以降に発売予定のフィギュアを取得
      upcoming_figures = user.figures.select { |figure| figure.release_month >= today.beginning_of_month }
      # フィギュアをハッシュ（release_month => [Figure1...]）で発売月ごとにまとめる
      figures_grouped_by_release_month = upcoming_figures.group_by(&:release_month)
      figures_grouped_by_release_month.each do |release_month, figures|
        # 今日が通知タイミングか確かめる
        next unless user.notification_date_for(release_month) == today
        # 未払いのフィギュアだけをフィルタリング
        unpaid_figures = figures.select(&:unpaid?)
        # 未払いのフィギュアの金額合計
        total_price = unpaid_figures.sum { |figure| figure.price * figure.quantity }
        FigureMailer.monthly_payment_summary(user, figures, release_month, total_price).deliver_now
      end
    end
  end
end
