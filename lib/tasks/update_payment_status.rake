namespace :payment_status do
  desc "発売月が翌月を迎えた場合、支払いステータスを自動で「支払い済み」に変更する"
  task update_payment_status: :environment do
    Figure.unpaid.where("release_month < ?", Date.current.beginning_of_month).find_each do |figure|
      retry_count = 0
      begin
        retry_count += 1
        figure.paid!
      rescue => e
        if retry_count < 4
          # 5秒、10秒、15秒と待機時間を伸ばす
          sleep(retry_count * 5)
          retry
        else
          # 3回でもダメならログ出力し、次のレコードへ
          Rails.logger.error("支払いステータス自動更新エラー: update_payment_status ID: #{figure.id} ERROR_MSG: #{e.message}")
        end
      end
    end
  end
end
