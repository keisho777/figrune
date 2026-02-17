class Figure < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255 }
  validates :release_month, presence: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :payment_status, presence: true
  validates :size_mm, numericality: { greater_than_or_equal_to: 1, allow_blank: true }
  validates :note, length: { maximum: 65_535 }
  validate :size_type_and_mm_consistency

  belongs_to :user
  belongs_to :manufacturer, optional: true
  belongs_to :work, optional: true
  belongs_to :shop, optional: true

  attr_accessor :work_name
  attr_accessor :shop_name
  attr_accessor :manufacturer_name

  # 支払いステータス：0:未払い、1:支払い済み
  enum payment_status: { unpaid: 0, paid: 1 }

  # 大きさの単位：0:全高、1:全長
  enum size_type: { overall_height: 0, overall_length: 1 }

  # Ransack で検索を許可するカラム一覧
  def self.ransackable_attributes(auth_object = nil)
      [ "name", "release_month", "created_at", "total_price" ]
  end

  # release_monthがXXXX-XXの形式だと保存できないためXXXX-XX-01にして回避するためのカスタムセッター
  # Xは数値です
  def release_month=(value)
    super(value + "-01")
  end

  # 以下3点の　assign_テーブル名_by_name　について
  # フォームで入力された名称をもとに、各関連モデルを取得（なければ作成）して Figure に紐付ける
  def assign_work_by_name(name)
    if name.blank?
      self.work = nil
      return
    end
    self.work = Work.find_or_create_by(name: name)
  end

  def assign_shop_by_name(name)
    if name.blank?
      self.shop = nil
      return
    end
    self.shop = Shop.find_or_create_by(name: name)
  end

  def assign_manufacturer_by_name(name)
    if name.blank?
      self.manufacturer = nil
      return
    end
    self.manufacturer = Manufacturer.find_or_create_by(name: name)
  end

  # 合計金額を保存するための計算メソッド
  def calculate_total_price
    return if self.price.blank? || self.quantity.blank?
    self.total_price = self.price * self.quantity
  end

  # 以下3点の　set_仮想カラム名_from_テーブル名　について
  # 編集画面を表示するとき、外部キーが設定されていれば、関連先テーブルのnameを取得して
  # 仮想カラムにセットする
  def set_work_name_from_work
    return if self.work_id.blank?
    self.work_name = Work.find_by(id: self.work_id).name
  end

  def set_shop_name_from_shop
    return if self.shop_id.blank?
    self.shop_name = Shop.find_by(id: self.shop_id).name
  end

  def set_manufacturer_name_from_manufacturer
    return if self.manufacturer_id.blank?
    self.manufacturer_name = Manufacturer.find_by(id: self.manufacturer_id).name
  end

  # 任意項目が入力されているか
  def optional_fields_filled?
    size_type.present? ||
    size_mm.present? ||
    work_name.present? ||
    shop_name.present? ||
    manufacturer_name.present? ||
    note.present?
  end

  private

  def size_type_and_mm_consistency
    if size_type.present? ^ size_mm.present?
      if size_type.present?
        errors.add(:size_mm, I18n.t("errors.messages.blank"))
      elsif size_mm.present?
        errors.add(:size_type, I18n.t("errors.messages.blank"))
      end
    end
  end
end
