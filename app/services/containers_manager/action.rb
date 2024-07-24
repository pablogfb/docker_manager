module ContainersManager
  class Action < ApplicationService
    
    def initialize(id, action)
      @id = id
      @action = action
    end
    
    def call
      container = Docker::Container.get(@id)
      container.start if @action == "start"
      container.stop if @action == "stop"
      container
    end
  end
end