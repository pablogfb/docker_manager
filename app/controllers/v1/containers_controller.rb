class V1::ContainersController < V1::ApiController
  def index
    containers = ContainersManager::FetchAll.call()
    render json: { status: { code: 200 }, data: containers }
  end

  def create
    container = ContainersManager::Create.call(params[:image])
    render json: { status: { code: 200 }, data: { container: container } }
  end

  def show
    container = ContainersManager::Info.call(params[:id])
    render json: { status: { code: 200 }, data: { container: container } }
  end

  def logs
    container = ContainersManager::Info.call(params[:id])
    # Need to force logs encoding
    render json: {
             status: {
               code: 200
             },
             data: {
               logs: container.logs(stdout: true).force_encoding("ISO-8859-1")
             }
           }
  end

  def destroy
    container = ContainersManager::Delete.call(params[:id])
    render json: { status: { code: 200 }, message: "Container deleted" }
  end

  def action
    container = ContainersManager::Action.call(params[:id], params[:command])
    render json: { status: { code: 200 }, data: { container: container } }
  end
end
