require 'soundcloud'

module Soundcloud2000
  class Client
    CLIENT_ID = '29f8e018e1272c27bff7d510a10da2a8'

    def initialize(client_id = CLIENT_ID)
      @client = Soundcloud.new(client_id: client_id)
    end

    def tracks
      @client.get('/tracks', limit: 10)
    end

  end
end
