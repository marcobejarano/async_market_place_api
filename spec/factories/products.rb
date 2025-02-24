FactoryBot.define do
  factory :product do
    title { Faker::Commerce.product_name }
    price { Faker::Commerce.price(range: 5.0..1000.0) }
    published { [ true, false ].sample }
    association :user, factory: :user
  end
end
