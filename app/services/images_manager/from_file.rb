module ImagesManager
  class FromFile < ApplicationService
    def initialize(dockerfile)
      @dockerfile = dockerfile
    end

    def call
      file_data = @dockerfile
      image = Docker::Image.build(file_data.read)
    end
  end
end
