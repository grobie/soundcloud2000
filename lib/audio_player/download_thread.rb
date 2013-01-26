require 'net/http'

module AudioPlayer
  class DownloadThread
    attr_reader :url, :progress, :total

    def initialize(logger, url, filename)
      @logger = logger
      @uri = URI.parse(url)
      @file = File.open(filename, "w")
      @progress = 0
      start!
    end

    def log(s)
      @logger.debug("DownloadThread #{s}")
    end

    def start!
      Thread.start do
        begin
          Net::HTTP.get_response(@uri) do |res|
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
