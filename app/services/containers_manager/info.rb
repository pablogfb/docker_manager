module ContainersManager
  class Info < ApplicationService
    
    def initialize(id)
      @id = id
    end
    
    def call
      container = Docker::Container.get(@id)
    end
  end
end