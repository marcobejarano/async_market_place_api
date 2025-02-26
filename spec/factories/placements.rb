FactoryBot.define do
  factory :placement do
    association :order, factory: :order
    association :product, factory: :product
    quantity { rand(10..20) }
  end
end
