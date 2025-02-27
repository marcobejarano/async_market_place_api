require 'rails_helper'

RSpec.describe "Api::V1::Products", type: :request do
  let!(:user) { create(:user) }
  let!(:products) { create_list(:product, 3, user: user) }
  let!(:product) { create(:product, user: user) }
  let(:product_params) { attributes_for(:product).merge(user_id: user.id) }
  let(:auth_token) { JsonWebToken.encode(user_id: user.id) }
  let(:headers) { { "Authorization" => auth_token } }
  let(:other_user) { create(:user) }
  let(:other_auth_token) { JsonWebToken.encode(user_id: other_user.id) }
  let(:other_headers) { { "Authorization" => other_auth_token } }

  describe "GET /api/v1/products" do
    it "returns a successful response with pagination links" do
      get api_v1_products_url, as: :json

      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body, symbolize_names: true)
      expect_json_response_to_be_paginated(json_response)
    end
  end

  describe "GET /api/v1/products/:id" do
    it "returns the product" do
      get api_v1_product_url(product), as: :json

      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body, symbolize_names: true)

      expect(json_response.dig(:data, :attributes, :title)).to eq(product.title)
      expect(json_response.dig(:data, :relationships, :user, :data, :id)).to eq(product.user.id.to_s)
      expect(json_response.dig(:included, 0, :attributes, :email)).to eq(product.user.email)
    end
  end

  describe "POST /api/v1/products" do
    context "when user is authenticated" do
      it "creates a product" do
        expect {
          post api_v1_products_url,
            params: { product: product_params },
            headers: headers,
            as: :json
        }.to change(Product, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context "when user is not authenticated" do
      it "forbids creating a product" do
        expect {
          post api_v1_products_url,
            params: { product: product_params },
            as: :json
        }.not_to change(Product, :count)

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "PATCH /api/v1/products/:id" do
    context "when user is authenticated" do
      it "updates the product" do
        patch api_v1_product_url(product),
          params: { product: { title: "Updated Title" } },
          headers: headers,
          as: :json

        expect(response).to have_http_status(:success)
        expect(product.reload.title).to eq("Updated Title")
      end
    end

    context "when user is not authorized" do
      it "forbids updating the product" do
        patch api_v1_product_url(product),
          params: { product: { title: "Updated Title" } },
          headers: other_headers,
          as: :json

        expect(response).to have_http_status(:forbidden)
        expect(product.reload.title).not_to eq("Updated Title")
      end
    end
  end

  describe "DELETE /api/v1/products/:id" do
    context "when user is authenticated and owns the product" do
      it "destroys the product" do
        expect {
          delete api_v1_product_url(product),
            headers: headers,
            as: :json
        }.to change(Product, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    context "when user is not authorized" do
      it "forbids deleting the products" do
        expect {
          delete api_v1_product_url(product),
            headers: other_headers,
            as: :json
        }.not_to change(Product, :count)

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
