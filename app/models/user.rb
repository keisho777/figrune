class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :figures , dependent: :destroy

  # 通知のタイミング：0:通知なし、1:1週間前、2:2週間前、3:3週間前、4:1か月前、 5:2か月前
  enum email_notification_timing: { disabled: 0, one_week_before: 1, two_week_before: 2, three_week_before: 3, one_month_before: 4, two_month_before: 5 }

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
end
