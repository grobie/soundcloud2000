require 'coreaudio'

require_relative 'download_thread'
require_relative 'audio_buffer'
require_relative 'play_thread'

module AudioPlayer
  class Player

    def initialize(logger, audio_folder = "~/.audio_player")
      @logger = logger
      @audio_folder = File.expand_path(audio_folder)
      @output_device = CoreAudio.default_output_device
      @output_buffer = @output_device.output_buffer(1024)
      @playing = false
      @position = 0
      @size = 100

      Dir.mkdir(@audio_folder) unless File.exist?(@audio_folder)
    end

    def load(url, id, &block)
      @play_thread.kill if @play_thread

      filename = "#{@audio_folder}/#{id}"
      DownloadThread.new(@logger, url, filename).start unless File.exist?(filename)
      @audio_buffer = AudioBuffer.new(@logger, filename).read

      @play_thread = PlayThread.new(@logger, @output_buffer, @audio_buffer) do |position, size|
        @position = position
        @size = size
        block.call(self)
      end
    end

    def play_progress
      @position.to_f / @size
    end

    def playing?
      @play_thread && @playing == true
    end

    def rewind
      @play_thread.rewind if @play_thread
    end

    def forward
      @play_thread.forward if @play_thread
    end

    def stop
      if playing?
        @play_thread.stop
        @playing = false
      end
    end

    def start
      if @play_thread && !playing?
        @play_thread.start
        @playing = true
      end
    end

    def toggle
      if playing?
        stop
      else
        start
      end
    end
  end
end
