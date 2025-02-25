FactoryBot.define do
  factory :order do
    association :user
    total { 9.99 }
  end
end
