FactoryBot.define do
  factory :user do
    email { "user@example.com" }
    password { "password" }
    password_confirmation { "password" }
    has_email { true }
    has_password { true }
    confirmed_at { Time.current }
  end
end
