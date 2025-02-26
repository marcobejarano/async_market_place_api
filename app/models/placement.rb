class Placement < ApplicationRecord
  belongs_to :order, inverse_of: :placements
  belongs_to :product, inverse_of: :placements

  def decrement_product_quantity!
    product.quantity -= quantity
    product.save
  end
end
