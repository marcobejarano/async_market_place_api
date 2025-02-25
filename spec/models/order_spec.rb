require 'rails_helper'

RSpec.describe Order, type: :model do
  let!(:user) { create(:user) }
  let(:order) { build(:order, user: user) }

  it "is a positive total" do
    order.total = -1
    expect(order).not_to be_valid
  end
end
