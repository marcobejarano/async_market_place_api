class Order < ApplicationRecord
  belongs_to :user
  has_many :placements, dependent: :destroy
  has_many :products, through: :placements

  validates :total, presence: true,
                    numericality: { greater_than_or_equal_to: 0 }

  before_validation :set_total
  after_commit :set_total, on: %i[create update]

  def set_total
    self.total = products.sum(:price)
  end
end
