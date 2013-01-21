require 'soundcloud'
require 'net/http'

module Soundcloud2000
  class Client
    DEFAULT_LIMIT = 50

    def initialize(client_id)
      @client = Soundcloud.new(client_id: client_id)
    end

    def tracks(page = 1, limit = DEFAULT_LIMIT)
      @client.get('/users/430558/tracks', offset: (page - 1) * limit, limit: limit)
    end

    def tracks_by_username(username, page = 1, limit = DEFAULT_LIMIT)
      begin
        resolve_user = @client.get('/resolve',
                                   :url => "http://soundcloud.com/#{username}")
        @client.get(resolve_user['uri'] + '/tracks', offset: (page - 1) * limit,
                    limit: limit)
      rescue Soundcloud::ResponseError
        nil
      end
    end

    def get(*args)
      @client.get(*args)
    end

    def client_id
      @client.client_id
    end

    def location(url)
      uri = URI.parse(url + '?client_id=' + client_id)
      Net::HTTP.get_response(uri) do |res|
        if res.code == '302'
          return res.header['Location']
        end
      end

      nil
    end

  end
end
