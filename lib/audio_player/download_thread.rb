require 'net/http'

module AudioPlayer
  class DownloadThread
    attr_reader :url, :progress, :total

    def initialize(url, filename)
      @uri = URI.parse(url)
      @file = File.open(filename, "w")
      @progress = 0
    end

    def join
      @thread.join
    end

    def kill
      @thread.kill
    end

    def start
      @thread = Thread.start do
        begin
          Net::HTTP.get_response(@uri) do |res|
            if res.code != '200'
              raise res.body
            end
            @total = res.header['Content-Length'].to_i
            res.read_body do |chunk|
              @progress += chunk.size
              @file << chunk
            end
          end
        rescue => e
          puts "#{inspect} #{e.inspect}"
        end
      end

      sleep 0.1 while @progress < 1_000_000 || @progress == @total
      self
    end
  end
end
