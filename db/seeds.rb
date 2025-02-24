Product.delete_all
User.delete_all

3.times do
  user = User.create!(
    email: Faker::Internet.email,
    password: "locadex1234"
  )
  puts "Created a new user: #{user.email}"

  2.times do
    product = Product.create!(
      title: Faker::Commerce.product_name,
      price: rand(5.0..100.0),
      published: [ true, false ].sample,
      user_id: user.id
    )
    puts "Created a brand new product: #{product.title}"
  end
end
