FactoryBot.define do
  factory :authentication do
    association :user
    provider { 'line' }
    uid { '123456' }
  end
end