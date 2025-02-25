FactoryBot.define do
  factory :placement do
    association :order
    association :product
  end
end
