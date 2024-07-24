module ImagesManager
  class FetchAll < ApplicationService
    
    def initialize
    end
    
    def call
      images = Docker::Image.all
      images.map! { |image| { id: image.id, tag: image.tag } }
    end
  end
end