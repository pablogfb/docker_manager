class V1::ContainersController < ApplicationController

  def index
    begin
      containers = Docker::Container.all(:all => true)
      containers.map! { |container| { 
                                      id: container.id, 
                                      image: container.info["ImageID"],
                                      names: container.info["Names"], 
                                      status: container.info["Status"]
                                    } 
                      }
      render json: { status: { code: 200 }, data: containers }
    rescue => error
      render json: { status: { code: 503 }, message: error.message  }, status: 503
    end
  end
  

  def create
    #TODO: docker container run
  end


  def show
    begin
      container = Docker::Container.get(params[:id])
      render json: { status: { code: 200 }, data: {container: container, logs: container.logs(stdout: true) } }
    rescue Docker::Error::NotFoundError
      render json: { status: { code: 404 }, message: 'Docker container not found' }, status: :not_found
    rescue => error
      render json: { status: { code: 503 }, message: error.message  }, status: 503
    end
  end


  def destroy
    begin
      container = Docker::Container.get(params[:id])
      container.stop
      container.remove
      render json: { status: { code: 200 }, message: 'Container deleted' }
    rescue Docker::Error::NotFoundError
      render json: { status: { code: 404 }, message: 'Docker Container not found'  }, status: :not_found
    rescue => error
      render json: { status: { code: 503 }, message: error.message  }, status: 503
    end
  end


end
