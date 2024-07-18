require 'rails_helper'

RSpec.describe "V1::Containers", type: :request do
  describe "GET /index" do
    describe "GET /" do
      it "returns success" do
        
        get "/v1/containers"
        expect(response.status).to eq(200)
        
        # Return Docker images list
        data = JSON.parse(response.body)["data"]
        expect(data).to match_json_schema("containers")
              
      end
    end
  end
end
