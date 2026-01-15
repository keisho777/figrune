class Figure < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :release_month, presence: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :payment_status, presence: true
  validates :size_mm, numericality: { greater_than_or_equal_to: 1, allow_blank: true }
  validates :note, length: { maximum: 65_535 }

  belongs_to :user
  belongs_to :manufacture, optional: true
  belongs_to :work, optional: true
  belongs_to :shop, optional: true

  attr_accessor :work_name
  attr_accessor :shop_name
  attr_accessor :manufacture_name

  # 支払いステータス：0:未払い、1:支払い済み
  enum payment_status: { unpaid: 0, paid: 1 }

  # 大きさの単位：0:全高、1:全長
  enum size_type: { overall_height: 0, overall_length: 1 }

  def self.ransackable_attributes(auth_object = nil)
      [ "name" ]
  end
  # release_monthがXXXX-XXの形式だと保存できないためXXXX-XX-01にして回避するためのカスタムセッター
  # Xは数値です
  def release_month=(value)
    super(value + "-01")
  end

  def assign_work_by_name(name)
    return if name.blank?
    self.work = Work.find_or_create_by(name: name)
  end

  def assign_shop_by_name(name)
    return if name.blank?
    self.shop = Shop.find_or_create_by(name: name)
  end

  def assign_manufacture_by_name(name)
    return if name.blank?
    self.manufacture = Manufacture.find_or_create_by(name: name)
  end
end
