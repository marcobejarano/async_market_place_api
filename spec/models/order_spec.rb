require 'rails_helper'

RSpec.describe Order, type: :model do
  let!(:user) { create(:user) }
  let!(:product_one) { create(:product, price: 25.0, quantity: 10) }
  let!(:product_two) { create(:product, price: 30.0, quantity: 10) }
  let(:order) { build(:order, user: user) }

  describe "total calculation" do
    it "calculates and sets the total based on placements" do
      order.placements = [
        Placement.new(product: product_one, quantity: 3),
        Placement.new(product: product_two, quantity: 2)
      ]

      order.set_total
      expected_total = (product_one.price * 3) + (product_two.price * 2)
      expect(order.total).to eq(expected_total)
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
