module ImagesManager
  class Delete < ApplicationService
    def initialize(id)
      @id = id
    end

    def call
      Docker::Image.remove(@id)
    end
  end
end
