FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password123' }
    password_digest { BCrypt::Password.create(password) }
  end
end
