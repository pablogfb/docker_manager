class V1::ImagesController < ApplicationController

  before_action :authenticate, only: :push

  def index
    begin
      images = Docker::Image.all
      images.map! { |image| {id: image.id, tag: image.tag} }
      render json: { status: { code: 200 }, data: images }
    rescue => error
      render json: { status: { code: 503 }, message: error.message  }, status: 503
    end
  end


  def create
    begin
      image = Docker::Image.build(request.raw_post)
      render json: { status: { code: 200 }, data: {image: image.id} }
    rescue => error
      render json: { status: { code: 503 }, message: error.message  }, status: 503
    end
  end

  def from_file
    begin
      file_data =  params[:dockerfile]
      image = Docker::Image.build(file_data.read)
      render json: { status: { code: 200 }, data: {image: image.id} }
    rescue => error
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

  def push

    begin
      image = Docker::Image.get(params[:id])
      image.tag(repo: "#{params[:serveraddress]}/#{params[:repo]}", tag: params[:tag])
      image.push
      render json: { status: { code: 200 }, message: 'Image pushed to registry' }
    rescue Docker::Error::NotFoundError
      render json: { status: { code: 404 }, message: 'Docker image not found'  }, status: :not_found
    rescue => error
      render json: { status: { code: 503 }, message: error.message  }, status: 503
    end
 
  end
  
  private

  def authenticate
    begin
      Docker.authenticate!(
                            'username'      => params[:username], 
                            'password'      => params[:password], 
                            'serveraddress' => params[:serveraddress]
                          )
    rescue => error
      render json: { status: { code: 403 }, message: error.message }, status: :forbidden
      return
    end 
  end

end
