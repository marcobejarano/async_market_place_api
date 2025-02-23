require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  let!(:user) { create(:user) }
  let(:auth_token) { JsonWebToken.encode(user_id: user.id) }
  let(:headers) { { "Authorization" => auth_token } }

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
    context "when authorized" do
      it "updates the user and returns success" do
        patch api_v1_user_url(user),
              params: { user: { email: user.email } },
              headers: headers,
              as: :json

        expect(response).to have_http_status(:success)
      end
    end

    context "when unauthorized" do
      it "forbids user update" do
        patch api_v1_user_url(user),
              params: { users: { email: user.email } },
              as: :json

        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when invalid parameters are provided" do
      it "does not update the user and returns unprocessable entity" do
        patch api_v1_user_url(user),
              params: { user: { email: "bad_email" } },
              headers: headers,
              as: :json

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /api/v1/users/:id" do
    context "when authorized" do
      it "destroys the user and returns no content" do
        expect {
          delete api_v1_user_url(user), headers: headers, as: :json
        }.to change(User, :count).by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end

    context "when unauthorized" do
      it "forbids the user deletion" do
        expect {
          delete api_v1_user_url(user), as: :json
        }.not_to change(User, :count)

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
