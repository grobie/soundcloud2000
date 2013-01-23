require 'ffi-portaudio'
require 'json'
require 'open3'

require_relative 'audio_buffer'
require_relative 'events'

module AudioPlayer
  class Player
    include FFI::PortAudio

    attr_reader :events

    PLAYER_PROCESS =
      File.expand_path(File.dirname(__FILE__) + "/../../bin/audio_player")

    def initialize(logger)
      @logger = logger
      @events = Events.new
      @spectrum = []
      reset
      start_process!
    end

    def start_process!
      @in, out, err, wait = Open3.popen3(PLAYER_PROCESS)

      Thread.start { read_commands_from err }
    end

    def load(url, &block)
      reset
      send!(:load, url)
    end

    def send!(*args)
      @logger.debug args.join(" ")
      @in.puts(args.to_json)
    end

    def read_commands_from(out)
      while line = out.gets
        begin
          if line[0,4] == 'JSON'
            send(*JSON.parse(line[5..-1]))
          else
            @logger.debug line.chomp
          end
        rescue => e
          @logger.debug e.message
          @logger.debug e.backtrace
        end
      end
    end

    def read_log_from(err)
      while line = err.gets
        @logger.debug line.chomp
      end
    rescue => e
      puts e.message
      puts e.backtrace
    end

    def on_position_change(position)
      @position = position.to_f / (44_100 * 2)
      events.trigger(:progress)
    end

    def on_spectrum(spectrum)
      @spectrum = spectrum
    end

    def spectrum
      @spectrum
    end

    def seconds_played
      @position
    end

    def playing?
      @playing == true
    end

    def rewind
      send! :rewind
    end

    def forward
      send! :forward
    end

    def stop
      send! :stop_stream if @playing
      @playing = false
    end

    def start
      send! :start_stream unless @playing
      @playing = true
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
      # send! :abort_stream if @playing
      @position = 0
      @size = 1/0.0
    end
  end
end

if __FILE__ == $0
  require 'logger'

  player = AudioPlayer::Player.new(Logger.new(STDOUT))
  player.load('http://localhost:8000/01.mp3')
  player.start

  sleep 20
end
