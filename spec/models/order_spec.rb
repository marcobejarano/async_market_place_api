require 'rails_helper'

RSpec.describe Order, type: :model do
  let!(:user) { create(:user) }
  let!(:product_one) { create(:product, price: 25.0) }
  let!(:product_two) { create(:product, price: 30.0) }

  describe "total calculation" do
    it "sets the total price based on products" do
      new_order = Order.new(user: user)
      new_order.products << product_one
      new_order.products << product_two
      new_order.save

      expect(new_order.total).to eq(product_one.price + product_two.price)
    end
  end
end
