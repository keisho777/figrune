class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: %i[line]

  attr_accessor :new_password
  attr_accessor :new_password_confirmation
  has_many :figures, dependent: :destroy
  has_many :authentications, dependent: :destroy

  # メール通知のタイミング：0:通知なし、1:1週間前、2:2週間前、3:3週間前、4:1か月前、 5:2か月前
  enum :email_notification_timing, { disabled: 0, one_week_before: 1, two_week_before: 2, three_week_before: 3, one_month_before: 4, two_month_before: 5 }, prefix: true
  
  # LINE通知のタイミング：0:通知なし、1:1週間前、2:2週間前、3:3週間前、4:1か月前、 5:2か月前
  enum :line_notification_timing, { disabled: 0, one_week_before: 1, two_week_before: 2, three_week_before: 3, one_month_before: 4, two_month_before: 5 }, prefix: true

  def notification_date_for(month_date)
    case email_notification_timing
    when "one_week_before"
      month_date - 1.week
    when "two_week_before"
      month_date - 2.weeks
    when "three_week_before"
      month_date - 3.weeks
    when "one_month_before"
      month_date - 1.month
    when "two_month_before"
      month_date - 2.months
    else
      nil
    end
  end

  def email_action_word
    has_email_in_database ? I18n.t("defaults.account_setting.update") : I18n.t("defaults.account_setting.setup")
  end

  # メール認証をクリックしたときの処理
  # has_emailで万が一、更新に失敗したときはロールバックする。
  def confirm(arg = {})
    ActiveRecord::Base.transaction do
      result = super  # Devise の元の confirm メソッドを呼ぶ
      update!(has_email: true) if result
      result
    end
    rescue => e
      Rails.logger.error(I18n.t("defaults.confirm_error_log", error: e.message))
      errors.add(:base, I18n.t("defaults.confirm_error"))
      false
  end
end
