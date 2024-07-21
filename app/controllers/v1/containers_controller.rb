class V1::ContainersController < V1::ApiController

  def index
    containers = Docker::Container.all(:all => true)
    containers.map! { |container| { 
                                    id: container.id, 
                                    image: container.info["ImageID"],
                                    names: container.info["Names"], 
                                    status: container.info["Status"]
                                  } 
                    }
    render json: { status: { code: 200 }, data: containers }
  end
  

  def create
    container = Docker::Container.create('Image': params[:image])
    render json: { status: { code: 200 }, data: {container: container} }
  end


  def show
    container = Docker::Container.get(params[:id])
    render json: { status: { code: 200 }, data: {container: container} }
  end

  def logs
    container = Docker::Container.get(params[:id])

    # Need to force logs encoding
    render json: { 
      status: { code: 200 }, 
      data: {logs: container.logs(stdout: true).force_encoding("ISO-8859-1")
      } }
  end


  def destroy
    container = Docker::Container.get(params[:id])
    container.stop
    container.remove
    render json: { status: { code: 200 }, message: 'Container deleted' }
  end

  def action
    container = Docker::Container.get(params[:id])
    container.start if params[:command] == 'start'
    container.stop if params[:command] == 'stop'
    render json: { status: { code: 200 }, data: {container: container } }
  end
end
