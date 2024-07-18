class V1::ContainersController < ApplicationController
  respond_to :json

  def index
    #TODO: docker container ls
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
