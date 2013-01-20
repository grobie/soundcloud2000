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
              @file << chunk
              log "finished" if @progress == @total
            end
          end
        rescue => e
          log e.message
        end
      end

      loop do
        sleep 0.01
        break if @progress > 65536 || (@total && @progress > @total / 2)
      end

      self
    end
  end
end
