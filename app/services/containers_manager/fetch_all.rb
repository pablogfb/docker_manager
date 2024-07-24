module ContainersManager
  class FetchAll < ApplicationService
    
    def initialize
    end
    
    def call
      containers = Docker::Container.all(all: true)
      containers.map! do |container|
        {
          id: container.id,
          image: container.info["ImageID"],
          names: container.info["Names"],
          status: container.info["Status"]
        }
      end
    end
  end
end