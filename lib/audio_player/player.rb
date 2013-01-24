require 'json'
require 'open3'

require_relative 'events'

module AudioPlayer
  class Player
    attr_reader :events

    AUDIO_PLAYER = File.expand_path(File.dirname(__FILE__) + "/../../bin/audio_player")

    def initialize(logger)
      @logger = logger
      @events = Events.new
      @spectrum = []
      reset
      start_process!
    end

    def start_process!
      @in, out, err, wait = Open3.popen3(AUDIO_PLAYER)

      # TODO for some strange reason only stderr works
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
          send(*JSON.parse(line))
        rescue => e
          @logger.debug line
        end
      end
    end

    def on_position_change(position)
      @position = position.to_f / (44_100 * 2)
      events.trigger(:progress)
    end

    def on_spectrum(spectrum)
      @spectrum = spectrum
    end

    def on_complete
      events.trigger(:complete)
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
      @position = 0
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
