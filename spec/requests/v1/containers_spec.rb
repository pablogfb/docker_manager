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

  describe "POST /" do 
    it "returns success and container data if image id exists" do 
      image = Docker::Image.build("FROM alpine\nRUN echo 'Hello, World!' > /test.txt ")
      post "/v1/containers", params: {image: image.id}
      expect(response.status).to eq(200)
      data = JSON.parse(response.body)["data"]
      expect(data).to match_json_schema("container")
    end

    it "returns success and container data if image name exists" do 
      image = Docker::Image.build("FROM alpine\nRUN echo 'Hello, World!' > /test.txt ")
      image.tag('repo' => 'test', 'tag' => 'latest', force: true)
      post "/v1/containers", params: {image: "test:latest"}
      expect(response.status).to eq(200)
      data = JSON.parse(response.body)["data"]
      expect(data).to match_json_schema("container")
    end

    it "returns 404 if image does not exists" do
      post "/v1/containers", params: {image: 'wrongimage'}
      expect(response.status).to eq(404)
    end
  end

  describe "GET /:id" do

    it "returns 404 if the container does not exist" do 
      
      get "/v1/containers/nonexistingcontainer"

      expect(response.status).to eq(404)
      expect(response.body).to eq('{"status":{"code":404},"message":"Docker entity not found"}')
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
      expect(response.body).to eq('{"status":{"code":404},"message":"Docker entity not found"}')
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

  describe "POST :id/action" do 
    it 'should start the container' do 

      image  = Docker::Image.create('fromImage' => 'nginx:1.27.0-alpine-slim')
      container = Docker::Container.create("Image": image.id)
      expect(container.json["State"]["Running"]).to eq(false)

      post "/v1/containers/#{container.id}/action", params: {command: "start"}
      expect(container.json["State"]["Running"]).to eq(true)
      container.stop
      container.remove(:force => true)
      image.remove(:force => true)
    end

    it 'should stop the container' do 

      image  = Docker::Image.create('fromImage' => 'nginx:1.27.0-alpine-slim')
      container = Docker::Container.create("Image": image.id)
      container.start     

      post "/v1/containers/#{container.id}/action", params: {command: "stop"}
      expect(container.json["State"]["Running"]).to eq(false)
      container.stop
      container.remove(:force => true)
      image.remove(:force => true)
    end
    
  end

end
