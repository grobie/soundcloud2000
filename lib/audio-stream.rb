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
          puts "#{inspect} #{e.inspect}"
        end
      end

      sleep 0.1 while @progress < 1_000_000 || @progress == @total
      self
    end
  end

  class AudioBuffer
    def initialize(file_path)
      @file = CoreAudio::AudioFile.new(file_path, :read)
      @frames = []
    end

    def read
      Thread.start do
        begin
          while buf = @file.read(1024)
            @frames << buf
          end
        rescue => e
          p self
          p e
          puts e.backtrace
        end
      end

      self
    end

    def [](i)
      @frames[i]
    end

    def size
      @frames.size
    end
  end

  class PlayThread
    def initialize(output_buffer, audio_buffer, sec_per_frame)
      @output_buffer = output_buffer
      @audio_buffer = audio_buffer
      @sec_per_frame = sec_per_frame
      @position = 0
    end

    def join
      @thread.join
    end

    def rewind
      @position -= 1 if @position > 0
    end

    def forward
      @position += 1 if @position < @audio_buffer.size - 2
    end

    def start
      @thread = Thread.start do
        begin
          sleep 0.1 while @audio_buffer.size < 50

          loop do
            if @position < @audio_buffer.size
              @output_buffer << @audio_buffer[@position]
              @position += 1
            end
            sleep @sec_per_frame
          end
        rescue => e
          p self
          p e
          puts e.backtrace
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
    download_thread = DownloadThread.new(url, filename).start unless File.exist?(filename)
    audio_buffer = AudioBuffer.new(filename).read
    output_buffer = @output_device.output_buffer(1024)
    @play_thread = PlayThread.new(output_buffer, audio_buffer, 1/1000).start
  end

  def stop
    @play_thread.kill
  end

  def join
    @play_thread.join
  end
end

stream = AudioStream.new
stream.play("http://233music.com//media/downloads/Tony%20Harmony%20-%20Happy%20Birthday%20ft.%20SK%20Original%20(www.233music.com).mp3", "01.mp3")

sleep 1000
