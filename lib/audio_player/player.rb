require 'coreaudio'

require_relative 'download_thread'
require_relative 'audio_buffer'
require_relative 'play_thread'

module AudioPlayer
  class Player
    attr_reader :playing

    def initialize(audio_folder = "~/.audio_player")
      @audio_folder = File.expand_path(audio_folder)
      @output_device = CoreAudio.default_output_device
      @output_buffer = @output_device.output_buffer(1024)
      @playing = false

      Dir.mkdir(@audio_folder) unless File.exist?(@audio_folder)
    end

    def load(url, id)
      @play_thread.kill if @play_thread

      filename = "#{@audio_folder}/#{id}"
      DownloadThread.new(url, filename).start unless File.exist?(filename)
      audio_buffer = AudioBuffer.new(filename).read

      @play_thread = PlayThread.new(@output_buffer, audio_buffer)
    end

    def rewind
      @play_thread.rewind if @play_thread
    end

    def forward
      @play_thread.forward if @play_thread
    end

    def stop
      if @play_thread && @playing
        @play_thread.stop
        @playing = false
      end
    end

    def start
      if @play_thread && !playing
        @play_thread.start
        @playing = true
      end
    end

    def toggle
      if @playing
        stop
      else
        start
      end
    end
  end
end
