require 'net/http'

module AudioPlayer
  class DownloadThread
    attr_reader :url, :total

    def initialize(logger, url, &callback)
      @logger = logger
      @uri = URI.parse(url)
      @buffer = ""
      @callback = callback
    end

    def progress
      @buffer.size
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
              @buffer << chunk
              @callback.call(chunk)
              log "finished" if progress == total
            end
          end
        rescue => e
          log e.message
        end
      end

      self
    end
  end
end
