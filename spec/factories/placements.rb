FactoryBot.define do
  factory :placement do
    association :order, factory: :order
    association :product, factory: :product
  end
end
