module ImagesManager
  class Tag < ApplicationService
    def initialize(options)
      @id = options[:id]
      @repo = options[:repo]
    end

    def call
      image = Docker::Image.get(@id)
      image.tag(repo: @repo)
      image.push
    end

  end
end