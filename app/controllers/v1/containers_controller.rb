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
    #TODO: docker container inspect / logs
  end

  def destroy
    #TODO: docker container rm
  end


end
