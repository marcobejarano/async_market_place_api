require 'rails_helper'

RSpec.describe "Api::V1::Tokens", type: :request do
  let!(:user) { create(:user, password: "g00d_pa$$") }

  describe "POST /api/v1/tokens" do
    context "with valid credentials" do
      it "returns a JWT token" do
        post api_v1_tokens_url, params: {
          user: {
            email: user.email,
            password: "g00d_pa$$"
          }
        }, as: :json

        expect(response).to have_http_status(:success)

        json_response = JSON.parse(response.body)
        expect(json_response["token"]).not_to be_nil
      end
    end

    context "with invalid credentials" do
      it "does not return a token" do
        post api_v1_tokens_url(), params: {
          user: {
            email: user.email,
            password: "b@d_p@$$"
          }
        }, as: :json

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
