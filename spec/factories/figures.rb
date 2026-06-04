FactoryBot.define do
  factory :figure do
    name { "TEST" }
    release_month { "2026-02-01" }
    quantity { 1 }
    price { 1000 }
    payment_status { :unpaid }
    total_price { calculate_total_price }
    association :user
  end
end
