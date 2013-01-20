require 'coreaudio'

require_relative 'download_thread'
require_relative 'audio_buffer'
require_relative 'play_thread'

module AudioPlayer
  class Player
    SLICE_LENGTH = 1024.0 / 44100

    def initialize(logger, audio_folder = "~/.audio_player")
      @logger = logger
      @audio_folder = File.expand_path(audio_folder)
      @output_device = CoreAudio.default_output_device
      @output_buffer = @output_device.output_buffer(1024)

      reset
      Dir.mkdir(@audio_folder) unless File.exist?(@audio_folder)
    end

    def load(url, id, &block)
      reset
      @play_thread.kill if @play_thread

      filename = "#{@audio_folder}/#{id}"
      DownloadThread.new(@logger, url, filename).start unless File.exist?(filename)
      @audio_buffer = AudioBuffer.new(@logger, filename).read

      @play_thread = PlayThread.new(@logger, @output_buffer, @audio_buffer) do |position, size, spectrum|
        @position = position * SLICE_LENGTH
        @size = size * SLICE_LENGTH
        @spectrum = spectrum
        block.call(self)
      end
    end

    def spectrum
      @spectrum
    end

    def seconds_played
      @position
    end

    def play_progress
      @position / @size
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
      @play_thread.stop if @play_thread
      @playing = false
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

    def reset
      stop
      @position = 0
      @size = 1/0.0
    end
  end
end
