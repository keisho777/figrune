class Figure < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :release_month, presence: true
  validates :quantity, presence: true
  validates :price, presence: true
  validates :payment_status, presence: true
  validates :note, length: { maximum: 65_535 }

  belongs_to :user
  belongs_to :manufacture, optional: true
  belongs_to :work, optional: true
  belongs_to :shop, optional: true
  
  # 支払いステータス：0:未払い、1:支払い済み
  enum payment_status: { unpaid: 0, paid: 1 }

  # 大きさの単位：0:全高、1:全長
  enum size_type: { overall_height: 0, overall_length: 1 }
end
