require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  let!(:user) { create(:user) }

  describe "GET /api/v1/users/:id" do
    it "returns the user" do
      get api_v1_user_url(user), as: :json

      expect(response).to have_http_status(:success)

      json_response = JSON.parse(response.body)
      expect(json_response["email"]).to eq(user.email)
    end
  end

  describe "POST /api/v1/users" do
    context "when valid parameters are provided" do
      it "creates a new user" do
        expect {
          post api_v1_users_url, params: {
            user: {
              email: "test@test.org",
              password: "123456"
            }
          }, as: :json
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context "when email is already taken" do
      it "does not create a new user" do
        expect {
          post api_v1_users_url, params: {
            user: {
              email: user.email,
              password: "123456"
            }
          }, as: :json
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /api/v1/users/:id" do
    context "with valid parameters" do
      it "updates the user and returns success" do
        patch api_v1_user_url(user), params: {
          user: {
            email: user.email,
            password: "123456"
          }
        }, as: :json

        expect(response).to have_http_status(:success)
      end
    end

    context "with invalid parameters" do
      it "does not update the user and returns unprocessable entity" do
        patch api_v1_user_url(user), params: {
          user: {
            email: "bad_email",
            password: "123456"
          }
        }, as: :json

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
