require 'soundcloud'

module Soundcloud2000
  class Client

    def initialize(client_id)
      @client = Soundcloud.new(client_id: client_id)
    end

    def tracks
      @client.get('/tracks', limit: 10)
    end

  end
end
