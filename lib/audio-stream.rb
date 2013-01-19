require "coreaudio"
require "net/http"

class AudioStream
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
          p e
        end
      end
      self
    end
  end

  class PlayThread
    def initialize(output_device, file_path)
      @output_buffer = output_device.output_buffer(1024)
      @file = CoreAudio::AudioFile.new(file_path, :read)
    end

    def join
      @thread.join
    end

    def start
      @thread = Thread.start do
        begin
          loop do
            buf = @file.read(1024)
            break if buf.nil?
            @output_buffer << buf
          end
        rescue => e
          p e
        end
      end

      @output_buffer.start
      self
    end

    def kill
      @file.stop
      @thread.kill
    end
  end

  def initialize(audio_folder = "~/.soundcloud2000-audio")
    @audio_folder = File.expand_path(audio_folder)
    @output_device = CoreAudio.default_output_device

    Dir.mkdir(@audio_folder) unless File.exist?(@audio_folder)
  end

  def play(url, id)
    @play_thread.kill if @play_thread

    filename = "#{@audio_folder}/#{id}"
    download = DownloadThread.new(url, filename).start

    while download.progress < 50_000
      sleep 0.1
    end

    @play_thread = PlayThread.new(@output_device, filename).start
  end

  def stop
    @play_thread.kill
  end

  def join
    @play_thread.join
  end
end
