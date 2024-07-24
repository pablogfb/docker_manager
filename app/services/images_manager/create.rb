module ImagesManager
  class Create < ApplicationService
    def initialize(dockerfile)
      @dockerfile = dockerfile
    end

    def call
      image = Docker::Image.build(@dockerfile)
    end
  end
end
