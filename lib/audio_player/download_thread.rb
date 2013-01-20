require 'net/http'

module AudioPlayer
  class DownloadThread
    attr_reader :url, :progress, :total

    def initialize(logger, url, filename)
      @logger = logger
      @uri = URI.parse(url)
      @file = File.open(filename, "w")
      @progress = 0
    end

    def log(s)
      @logger.debug("DownloadThread #{s}")
    end

    def start
      @thread = Thread.start do
        begin
          log :thread_start
          Net::HTTP.get_response(@uri) do |res|
            log "response code = #{res.code}"

            if res.code != '200'
              raise res.body
            end

            @total = res.header['Content-Length'].to_i
            log "content length = #@total"

            res.read_body do |chunk|
              @progress += chunk.size
              log "progress = #@progress"
              @file << chunk
            end
          end
        rescue => e
          log e.message
        end
      end

      while @progress < 20_000 || @progress > @total / 2
        sleep 0.1
      end

      self
    end
  end
end
