require 'rails_helper'

RSpec.describe "Api::V1::Orders", type: :request do
  let!(:user) { create(:user) }
  let!(:product) { create(:product) }
  let!(:order) { create(:order, user: user, products: [ product ]) }
  let(:auth_token) { JsonWebToken.encode(user_id: user.id) }
  let(:headers) { { "Authorization" => auth_token } }

  describe "GET /api/v1/orders" do
    context "when user is not logged in" do
      it "forbids access to orders" do
        get api_v1_orders_url, as: :json
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when user is logged in" do
      it "returns the user's orders" do
        get api_v1_orders_url,
          headers: headers,
          as: :json

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body)
        expect(json_response["data"].size).to eq(user.orders.count)
      end
    end
  end

  describe "GET /api/v1/orders/:id" do
    context "when user is not logged in" do
      it "forbids access to order" do
        get api_v1_order_url(order), as: :json
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when user is logged in" do
      it "returns the order" do
        get api_v1_order_url(order),
          headers: headers,
          as: :json

        expect(response).to have_http_status(:success)
        json_response = JSON.parse(response.body, symbolize_names: true)
        include_product_attr = json_response.dig(:included, 0, :attributes)
        expect(include_product_attr[:title]).to eq(order.products.first.title)
      end
    end
  end
end
