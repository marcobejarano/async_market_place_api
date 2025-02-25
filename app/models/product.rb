class Product < ApplicationRecord
  belongs_to :user
  has_many :placements, dependent: :destroy
  has_many :orders, through: :placements

  validates :title, :user_id, presence: true
  validates :price, presence: true,
                    numericality: { greater_than_or_equal_to: 0 }

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

  scope :by_product_ids, ->(ids) {
    where(id: ids) if ids.present?
  }

  def self.search(params = {})
    products = Product.all
    products = products.filter_by_title(params[:keyword]) if params[:keyword].present?
    products = products.above_or_equal_to_price(params[:min_price]) if params[:min_price].present?
    products = products.below_or_equal_to_price(params[:max_price]) if params[:max_price].present?
    products = products.by_product_ids(params[:product_ids]) if params[:product_ids].is_a?(Array) && params[:product_ids].present?

    products.recent
  end
end
