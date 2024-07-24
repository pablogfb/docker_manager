class V1::ImagesController < V1::ApiController
  def index
    images = ImagesManager::FetchAll.call
    render json: { status: { code: 200 }, data: images }
  end

  def create
    image = ImagesManager::Create.call(request.raw_post)
    render json: { status: { code: 200 }, data: { image: image.id } }
  end

  def from_file
    image = ImagesManager::FromFile.call(params[:dockerfile])
    render json: { status: { code: 200 }, data: { image: image.id } }
  end

  def show
    image = ImagesManager::Info.call(params[:id])
    render json: { status: { code: 200 }, data: image }
  end

  def destroy
    ImagesManager::Delete.call(params[:id])
    render json: { status: { code: 200 }, message: "Image deleted" }
  end

  def push
    ImagesManager::Push.call(
      {
        id: params[:id],
        username: params[:username],
        password: params[:password],
        serveraddress: params[:serveraddress],
        repo: params[:repo],
        tag: params[:tag]
      }
    )
    render json: {status: {code: 200}, message: "Image pushed to registry"}
  end

  def tag
    ImagesManager::Tag.call(
      {
        id: params[:id],
        repo: params[:repo]
      }
    )
    render json: { status: { code: 200 }, message: "Image tagged" }
  end
end
