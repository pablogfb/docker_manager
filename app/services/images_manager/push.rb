module ImagesManager
  class Push < ApplicationService
    def initialize(options)
      @id = options[:id]
      @username = options[:username]
      @password = options[:password]
      @serveraddress = options[:serveraddress]
      @repo = options[:repo]
      @tag = options[:tag]
      authenticate()
    end

    def call
      image = Docker::Image.get(@id)
      image.tag(repo: "#{@serveraddress}/#{@repo}", tag: @tag)
      image.push
    end

    private

    def authenticate
      Docker.authenticate!(
        "username" => @username,
        "password" => @password,
        "serveraddress" => @serveraddress
      )
    end
  end
end
