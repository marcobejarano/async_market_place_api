require 'rails_helper'

class MockController
  include Authenticable
  attr_accessor :request

  def initialize
    mock_request = Struct.new(:headers)
    self.request = mock_request.new({})
  end
end

RSpec.describe Authenticable, type: :concern do
  let(:user) { create(:user) }
  let(:authentication) { MockController.new }

  describe "#current_user" do
    context "when Authorization token is provided" do
      before do
        authentication.request.headers['Authorization'] = JsonWebToken.encode(user_id: user.id)
      end

      it "returns the authenticatd user" do
        expect(authentication.current_user).not_to be_nil
        expect(authentication.current_user.id).to eq(user.id)
      end
    end

    context "when Authorization token is not provided" do
      before do
        authentication.request.headers['Authorization'] = nil
      end

      it "returns nil" do
        expect(authentication.current_user).to be_nil
      end
    end
  end
end
