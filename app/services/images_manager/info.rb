module ImagesManager
  class Info < ApplicationService
    def initialize(id)
      @id = id
    end

    def call
      image = Docker::Image.get(@id)
    end
  end
end
