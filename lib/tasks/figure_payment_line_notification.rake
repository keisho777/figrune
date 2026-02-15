namespace :reminders do
  desc "フィギュアの月別支払い合計額をLINE通知"
  task figure_payment_line_notification: :environment do
      today = Date.current
      client = Line::Bot::V2::MessagingApi::ApiClient.new(
        channel_access_token: ENV["LINE_CHANNEL_TOKEN"]
      )

    User.joins(:authentications).where(authentications: { provider: "line" }).includes(:figures, :authentications).find_each do |user|
      # 今月以降に発売予定のフィギュアを取得
      upcoming_figures = user.figures.select { |figure| figure.release_month >= today.beginning_of_month }
      # フィギュアをハッシュ（release_month => [Figure1...]）で発売月ごとにまとめる
      figures_grouped_by_release_month = upcoming_figures.group_by(&:release_month)
      figures_grouped_by_release_month.each do |release_month, figures|
        # 今日が通知タイミングか確かめる
        next unless user.notification_date_for(release_month, "line") == today

        # 未払いのフィギュアだけをフィルタリング
        unpaid_figures = figures.select(&:unpaid?)

        # 未払いのフィギュアの金額合計
        unpaid_total_price = unpaid_figures.sum(&:total_price)

        info = "#{release_month.strftime("%Y年%-m月")}発売予定のフィギュアのお知らせです。\n\n"
        total = "▼お支払予定の合計金額\n￥#{unpaid_total_price.to_formatted_s(:delimited)}\n\n"
        list = "▼発売予定リスト\n#{figures.map { |f| "・#{f.name}" }.join("\n")}"

        # メッセージ内容
        message = Line::Bot::V2::MessagingApi::TextMessage.new(
          text: info + total + list
        )

        # 誰にメッセージを送るか設定
        request = Line::Bot::V2::MessagingApi::PushMessageRequest.new(
          to: user.authentications.find_by(provider: "line").uid,
          messages: [ message ]
        )

        # ここでpush通知
        response, status_code, response_headers = client.push_message_with_http_info(
          push_message_request: request
        )
      end
    end
  end
end
