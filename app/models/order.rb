class Order < ApplicationRecord
  belongs_to :user
  has_many :placements, dependent: :destroy
  has_many :products, through: :placements

  validates :total, presence: true,
                    numericality: { greater_than_or_equal_to: 0 }
  validates_with SufficientProductQuantityValidator

  before_validation :set_total
  after_commit :set_total, on: %i[create update]

  def set_total
    self.total = self.placements.map {
      |placement| placement.product.price * placement.quantity
    }.sum
  end

  def build_placements_with_product_ids_and_quantities(product_ids_and_quantities)
    product_ids_and_quantities.each do |product_id_and_quantity|
      placement = placements.build(
        product_id: product_id_and_quantity[:product_id],
        quantity: product_id_and_quantity[:quantity]
      )

      yield placement if block_given?
    end
  end
end
