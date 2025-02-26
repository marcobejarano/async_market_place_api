require 'rails_helper'

RSpec.describe Order, type: :model do
  let!(:user) { create(:user) }
  let!(:product_one) { create(:product, price: 25.0, quantity: 10) }
  let!(:product_two) { create(:product, price: 30.0, quantity: 10) }
  let(:order) { build(:order, user: user) }

  describe "total calculation" do
    it "sets the total price based on products" do
      new_order = Order.new(user: user)
      new_order.products << product_one
      new_order.products << product_two
      new_order.save

      expect(new_order.total).to eq(product_one.price + product_two.price)
    end
  end

  describe "building placements" do
    let(:placements_data) do
      [
        { product_id: product_one.id, quantity: 2 },
        { product_id: product_two.id, quantity: 3 }
      ]
    end

    it "creates placements for the order" do
      order.build_placements_with_product_ids_and_quantities(placements_data)

      expect { order.save }.to change(Placement, :count).by(2)
    end
  end

  describe "validations" do
    it "is invalid if an order claims more products than available" do
      order.placements.build(product: product_one, quantity: product_one.quantity + 1)

      expect(order).not_to be_valid
    end
  end
end
