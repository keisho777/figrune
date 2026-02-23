FactoryBot.define do
  factory :figure do
    name { "TEST" }
    release_month { "2026-02" }
    quantity { 1 }
    price { 1000 }
    payment_status { :unpaid }
    association :user
  end
end
