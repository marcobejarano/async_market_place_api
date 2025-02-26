class SufficientProductQuantityValidator < ActiveModel::Validator
  def validate(order)
    order.placements.each do |placement|
      product = placement.product
      if placement.quantity > product.quantity
        order.errors.add(:base, "Not enough stock for #{product.title}")
      end
    end
  end
end
