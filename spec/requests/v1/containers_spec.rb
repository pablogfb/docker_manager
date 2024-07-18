require 'rails_helper'

RSpec.describe "V1::Containers", type: :request do
  describe "GET /" do
    it "returns success" do
      
      get "/v1/containers"
      expect(response.status).to eq(200)
      
      # Return Docker images list
      data = JSON.parse(response.body)["data"]
      expect(data).to match_json_schema("containers")
            
    end
  end

  describe "GET /:id" do

    it "returns 404 if the container does not exist" do 
      
      get "/v1/containers/nonexistingcontainer"

      expect(response.status).to eq(404)
      expect(response.body).to eq('{"status":{"code":404},"message":"Docker container not found"}')
    end

    it "returns the container info if the container exists" do 
      
      image = Docker::Image.build("FROM alpine\nRUN echo 'Hello, World!' > /test.txt ")
      container = Docker::Container.create("Image": image.id)

      get "/v1/containers/#{container.id}"
      expect(response.status).to eq(200)
      expect(response).to match_json_schema("container")
      container.remove(:force => true)
      image.remove(:force => true)

    end
    
  end


  describe "DELETE /:id" do 
    it "returns 404 if the container does not exist" do 
      
      delete "/v1/containers/nonexistingcontainer"

      expect(response.status).to eq(404)
      expect(response.body).to eq('{"status":{"code":404},"message":"Docker Container not found"}')
    end


    it "returns success and delete the container if the container exists and is not running" do 
      
      image = Docker::Image.build("FROM alpine\nRUN echo 'Hello, World!' > /test.txt ")
      container = Docker::Container.create("Image": image.id)
      container.stop

      delete "/v1/containers/#{container.id}"
      expect(response.status).to eq(200)
      image.remove(:force => true)

    end

    it "returns success and delete the container if the container exists and is running" do 
      
      image = Docker::Image.build("FROM alpine\nRUN echo 'Hello, World!' > /test.txt ")
      container = Docker::Container.create("Image": image.id)

      delete "/v1/containers/#{container.id}"
      expect(response.status).to eq(200)
      image.remove(:force => true)

    end
    
  end
end
