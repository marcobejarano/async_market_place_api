require 'rails_helper'

RSpec.describe "Api::V1::Orders", type: :request do
  let!(:user) { create(:user) }
  let!(:product_one) { create(:product) }
  let!(:product_two) { create(:product) }
  let!(:order) { create(:order, user: user, products: [ product_one, product_two ]) }
  let(:auth_token) { JsonWebToken.encode(user_id: user.id) }
  let(:headers) { { "Authorization" => auth_token } }
  let(:order_params) do
    {
      order: {
        product_ids_and_quantities: [
          { product_id: product_one.id, quantity: 2 },
          { product_id: product_two.id, quantity: 3 }
        ]
      }
    }
  end

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

  describe "POST /api/v1/orders" do
    context "when user is not logged in" do
      it "forbids creating an order" do
        expect {
          post api_v1_orders_url,
            params: order_params,
            as: :json
        }.not_to change(Order, :count)

        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when user is logged in" do
      it "creates an order with two products" do
        expect {
          post api_v1_orders_url,
          headers: headers,
          params: order_params,
          as: :json
        }.to change(Order, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end
  end
end
