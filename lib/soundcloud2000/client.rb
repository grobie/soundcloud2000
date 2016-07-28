require 'net/http'
require 'json'

module Soundcloud2000
  # responsible for the very basic information of the app
  class Client
    DEFAULT_LIMIT = 50

    attr_reader :client_id, :current_user
    attr_writer :current_user

    def initialize(client_id)
      @client_id = client_id
      @current_user = nil
    end

    def tracks(page = 1, limit = DEFAULT_LIMIT)
      get('/tracks', offset: (page - 1) * limit, limit: limit)
    end

    def resolve(permalink)
      res = get('/resolve', url: "http://soundcloud.com/#{permalink}")
      if res['location']
        get URI.parse(res['location']).path
      end
    end

    def uri_escape(params)
      URI.escape(params.collect { |k, v| "#{k}=#{v}" }.join('&'))
    end

    def request(type, path, params = {})
      params[:client_id] = client_id
      params[:format] = 'json'

      Net::HTTP.start('api.soundcloud.com', 443, use_ssl: true) do |http|
        http.request(type.new("#{path}?#{uri_escape params}"))
      end
    end

    def get(path, params = {})
      JSON.parse(request(Net::HTTP::Get, path, params).body)
    end

    def location(url)
      uri = URI.parse(url)
      res = request(Net::HTTP::Get, uri.path)
      res.header['Location'] if res.code == '302'
    end
  end
end
