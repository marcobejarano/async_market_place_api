require 'rails_helper'

RSpec.describe Product, type: :model do
  subject { build(:product) }

  it "is invalid with a negative price" do
    subject.price = -1
    expect(subject).not_to be_valid
  end
end
