module ContainersManager
  class Delete < ApplicationService
    
    def initialize(id)
      @id = id
    end
    
    def call
      container = Docker::Container.get(@id)
      container.stop
      container.remove
      container
    end
  end
end