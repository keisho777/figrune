class Manufacturer < ApplicationRecord
  validates :name, length: { maximum: 100 }
  has_many :figures
end
