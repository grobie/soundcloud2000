require 'net/https'
require_relative 'events'

module Soundcloud2000
  class DownloadThread
    attr_reader :events, :url, :progress, :total, :file

    def initialize(url, filename)
      @events = Events.new
      @url = URI.parse(url)
      @file = File.open(filename, "w")
      @progress = 0
      start!
    end

    def log(s)
      Soundcloud2000::Application.logger.debug("DownloadThread #{s}")
    end

    def start!
      Thread.start do
        begin
          log :start

          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = true

          http.request(Net::HTTP::Get.new(url.request_uri)) do |res|
            log "response: #{res.code}"
            raise res.body if res.code != '200'

            @total = res.header['Content-Length'].to_i

            res.read_body do |chunk|
              @progress += chunk.size
              @file << chunk
              @file.close if @progress == @total
            end
          end
        rescue => e
          log e.message
        end
      end

      sleep 0.1 while @total.nil?
      sleep 0.1

      self
    end
  end
end
