class V1::ImagesController < ApplicationController

  def index
    images = Docker::Image.all
    images.map! { |image| {id: image.id, tag: image.tag} }
    render json: { status: { code: 200 }, data: images }
  end


  def create
    begin
    image = Docker::Image.build(request.raw_post)
    render json: { status: { code: 200 }, data: {image: image.id} }
    rescue => error
      puts error.message
      render json: { status: { code: 503 }, message: error.message  }, status: 503
    end
  end


  def show
    begin
      image = Docker::Image.get(params[:id])
      render json: { status: { code: 200 }, data: image }
    rescue Docker::Error::NotFoundError
      render json: { status: { code: 404 }, message: 'Docker image not found'  }, status: :not_found
    rescue => error
      render json: { status: { code: 503 }, message: error.message  }, status: 503
    end
  end


  def destroy 
    begin
      Docker::Image.remove(params[:id])
      render json: { status: { code: 200 }, message: 'Image deleted' }
    rescue Docker::Error::NotFoundError
      render json: { status: { code: 404 }, message: 'Docker image not found'  }, status: :not_found
    rescue => error
      render json: { status: { code: 503 }, message: error.message  }, status: 503
    end
  end
  

end
