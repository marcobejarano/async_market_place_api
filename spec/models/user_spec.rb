require "rails_helper"

RSpec.describe User, type: :model do
  subject { build(:user) }

  it "is valid with a valid email" do
    subject.email = "test@test.org"
    subject.password_digest = "test"
    expect(subject).to be_valid
  end

  it "is invalid with an improperly formatted email" do
    subject.email = "invalid_email"
    expect(subject).not_to be_valid
  end

  it "is invalid with a duplicate email" do
    create(:user, email: "duplicate@test.org")
    subject.email = "duplicate@test.org"
    expect(subject).not_to be_valid
  end
end
