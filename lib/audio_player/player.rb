require 'ffi-portaudio'

require_relative 'audio_buffer'
require_relative 'play_thread'

module AudioPlayer
  class Player
    include FFI::PortAudio

    def initialize(logger)
      @logger = logger
      API.Pa_Initialize
      reset
    end

    def load(url, id, &block)
      reset

      @buffer = AudioBuffer.new(@logger, url)
      @buffer.start

      sleep 5

      @play_thread = PlayThread.new(@logger, @buffer)
      @play_thread.start
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

if __FILE__ == $0
  require 'logger'

  player = AudioPlayer::Player.new(Logger.new(STDOUT))
  player.load('http://localhost:8000/01.mp3', '1')

  sleep 20
end
