FactoryBot.define do
  factory :user do
    email { "test@example.com" }
    password_digest { "hashed_password" }
  end
end
