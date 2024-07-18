class V1::ImagesController < ApplicationController

  def index
    images = Docker::Image.all
    images.map! { |image| {id: image.id, tag: image.tag} }
    render json: { status: { code: 200 }, data: images }
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
