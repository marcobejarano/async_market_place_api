require 'rails_helper'

RSpec.describe Product, type: :model do
  let!(:tv) { create(:product, title: "TV", price: 100, created_at: 3.days.ago) }
  let!(:another_tv) { create(:product, title: "Another TV", price: 200, created_at: 2.days.ago) }
  let!(:other_product) { create(:product, title: "Laptop", price: 500, created_at: 1.day.ago) }

  describe "validations" do
    subject { build(:product) }
    it "is invalid with a negative price" do
      subject.price = -1
      expect(subject).not_to be_valid
    end
  end

  describe ".filter_by_title" do
    it "filters products by name" do
      expect(Product.filter_by_title("TV").count).to eq(2)
    end

    it "filters products by name and sorts them" do
      expect(Product.filter_by_title("TV")).to eq([ another_tv, tv ])
    end
  end

  describe ".above_or_equal_to_price" do
    it "filters products by minimum price and sorts them" do
      expect(Product.above_or_equal_to_price(200)).to eq([ another_tv, other_product ])
    end

    it "filters products by maximum price and sorts them" do
      expect(Product.below_or_equal_to_price(200)).to eq([ tv, another_tv ])
    end
  end

  describe ".recent" do
    it "returns products sorted by most recent first" do
      expect(Product.recent).to eq([ other_product, another_tv, tv ])
    end
  end
end
