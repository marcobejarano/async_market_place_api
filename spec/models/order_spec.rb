require 'rails_helper'

RSpec.describe Order, type: :model do
  let!(:user) { create(:user) }
  let!(:product_one) { create(:product, price: 25.0) }
  let!(:product_two) { create(:product, price: 30.0) }
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
end
