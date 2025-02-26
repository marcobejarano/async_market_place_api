require 'rails_helper'

RSpec.describe Placement, type: :model do
  let!(:product) { create(:product, quantity: 10) }
  let!(:placement) { create(:placement, product: product, quantity: 3) }

  describe "#decrement_product_quantity!" do
    it "decreases the product quantity by the placement quantity" do
      expect { placement.decrement_product_quantity! }.to change { product.reload.quantity }.by(-placement.quantity)
    end
  end
end
