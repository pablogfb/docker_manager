require 'rails_helper'

RSpec.describe "V1::Images", type: :request do
  describe "GET /" do
    it "returns success" do
      
      get "/v1/images"
      expect(response.status).to eq(200)
      
      # Return Docker images list
      expect(response).to match_json_schema("images")
            
    end
  end

  describe "GET /:id" do 
    it "returns 404 if the image does not exist" do 
      
      get "/v1/images/nonexistingimage"

      expect(response.status).to eq(404)
      expect(response.body).to eq('{"status":{"code":404},"message":"Docker image not found"}')
    end

    it "returns the image info if the image exists" do 
      
      image = Docker::Image.build("FROM alpine\nRUN echo 'Hello, World!' > /test.txt ")

      get "/v1/images/#{image.id}"
      expect(response.status).to eq(200)
      expect(response).to match_json_schema("image")

      image.remove(:force => true)
    end

  end


  describe "DELETE /:id" do 

    it "returns 404 if the image does not exist" do 
      
      delete "/v1/images/nonexistingimage"

      expect(response.status).to eq(404)
      expect(response.body).to eq('{"status":{"code":404},"message":"Docker image not found"}')
    end

    it "returns success and delete the image if the image exists" do 
      
      image = Docker::Image.build("FROM alpine\nRUN echo 'Hello, World!' > /test.txt ")

      delete "/v1/images/#{image.id}"
      expect(response.status).to eq(200)

    end

    it "returns conflict if the image is running in a container" do 
      
      image = Docker::Image.build("FROM alpine\nRUN echo 'Hello, World!' > /test.txt ")
      container = Docker::Container.create( "Image": image.id)

      delete "/v1/images/#{image.id}"
      expect(response.status).to eq(503)
      expect(response.body).to start_with('{"status":{"code":503},"message":"{\"message\":\"conflict: unable to delete')
      container.remove(:force => true)
      image.remove(:force => true)

    end
  end

  describe "POST /" do 

    it "should build the image and return the id" do 

      post "/v1/images", params: "FROM alpine\nRUN echo 'Hello, World!' > /test.txt "
      
      expect(response.status).to eq(200)
      data = JSON.parse(response.body)["data"]
      expect(data).to match_json_schema("image_build")

      Docker::Image.remove(data["image"])

    end

    it "it should describe the error in case of failure" do 
       
      post "/v1/images", params: "Not valid dockerfile"

      expect(response.status).to eq(503)
      expect(response.body).to start_with('{"status":{"code":503},"message":"{\"message\":\"')
    end




  end


end
