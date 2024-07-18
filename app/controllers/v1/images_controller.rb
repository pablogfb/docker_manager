class V1::ImagesController < ApplicationController
  respond_to :json

  def index
    # TODO: docker image ls
  end

  def create
    # TODO: Create (build) new image from Dockerfile
  end

  def show
    # TODO: docker image inspect
  end

  def destroy 
    # TODO: docker image rm
  end
  

end
