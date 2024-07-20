class V1::ImagesController < V1::ApiController

  before_action :authenticate, only: :push

  def index
    images = Docker::Image.all
    images.map! { |image| {id: image.id, tag: image.tag} }
    render json: { status: { code: 200 }, data: images }
  end


  def create
    image = Docker::Image.build(request.raw_post)
    render json: { status: { code: 200 }, data: {image: image.id} }
  end

  def from_file
    file_data =  params[:dockerfile]
    image = Docker::Image.build(file_data.read)
    render json: { status: { code: 200 }, data: {image: image.id} }
  end

  def show
    image = Docker::Image.get(params[:id])
    render json: { status: { code: 200 }, data: image }
  end


  def destroy 
    Docker::Image.remove(params[:id])
    render json: { status: { code: 200 }, message: 'Image deleted' }
  end

  def push
    image = Docker::Image.get(params[:id])
    image.tag(repo: "#{params[:serveraddress]}/#{params[:repo]}", tag: params[:tag])
    image.push
    render json: { status: { code: 200 }, message: 'Image pushed to registry' }
  end
  
  private

  def authenticate
    Docker.authenticate!(
                          'username'      => params[:username], 
                          'password'      => params[:password], 
                          'serveraddress' => params[:serveraddress]
                        )
  end

end
