module ContainersManager
  class Create < ApplicationService
    
    def initialize(image)
      @image = image
    end
    
    def call
      container = Docker::Container.create(Image: @image)
    end
  end
end