class Product < ApplicationRecord
  belongs_to :user

  validates :title, :user_id, presence: true
  validates :price, presence: true,
                    numericality: { greater_than_or_equal: 0 }

  scope :filter_by_title, ->(query) {
    where("title ILIKE ?", "%#{query}%").order(title: :asc)
  }

  scope :above_or_equal_to_price, ->(price) {
    where("price >= ?", price).order(price: :asc)
  }

  scope :below_or_equal_to_price, ->(price) {
    where("price <= ?", price).order(price: :asc)
  }

  scope :recent, -> { order(created_at: :desc) }
end
