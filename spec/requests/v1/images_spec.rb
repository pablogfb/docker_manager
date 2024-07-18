require 'rails_helper'

RSpec.describe "V1::Images", type: :request do
  describe "GET /index" do
    it "returns success" do
      
      get "/v1/images"
      expect(response.status).to eq(200)
      
      # Return Docker images list
      expect(response).to match_json_schema("images")
            
    end

  end
end
