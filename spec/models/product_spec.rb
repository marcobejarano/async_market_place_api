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

  describe ".search" do
    it 'find "laptop" with min price of 400' do
      search_hash = { keyword: "laptop", min_price: 400 }
      expect(Product.search(search_hash)).to eq([ other_product ])
    end

    it "find cheap TV within price range" do
      search_hash = { keyword: "tv", min_price: 50, max_price: 150 }
      expect(Product.search(search_hash)).to eq([ tv ])
    end

    it "returns all products when no parameters are specified" do
      expect(Product.search({})).to match_array(Product.all)
    end

    it "filters by product IDs" do
      search_hash = { product_ids: [ other_product.id ] }
      expect(Product.search(search_hash)).to eq([ other_product ])
    end
  end
end
