require 'json'
require 'open3'

require_relative 'events'
require_relative 'download_thread'

module AudioPlayer
  class Player
    attr_reader :events

    AUDIO_PLAYER = File.expand_path(File.dirname(__FILE__) + "/../../bin/audio_player")

    def initialize(logger)
      @logger = logger
      @events = Events.new
      @spectrum = []
      @folder = File.expand_path("~/.soundcloud2000")
      Dir.mkdir(@folder) unless File.exist?(@folder)
      reset
      start_process!
    end

    def start_process!
      @in, out, err, wait = Open3.popen3(AUDIO_PLAYER)

      # TODO for some strange reason only stderr works
      Thread.start { read_commands_from err }
    end

    def load(track, location, &block)
      reset

      filename = "#{@folder}/#{track.id}.mp3"

      # delete any cached file that didn't stream completely
      if File.exists?(filename)
        begin
          cmd = "ffmpeg -i #{filename} 2>&1 |
            sed -n \"s/.*Duration: \\([^,]*\\).*/\\1/p\""
          cached_duration = parse_cached_duration(%x[ #{cmd} ])
          if cached_duration < track['duration'] * 0.95
            File.delete(filename)
          end
        rescue => e
          @logger.warn('Error checking cached stream')
          @logger.warn(e.message)
          File.delete(filename)
        end
      end

      DownloadThread.new(@logger, location, filename) unless File.exist?(filename)

      send!(:load, filename)
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
      @position = position
      events.trigger(:progress)
    end

    def on_level(level)
      @level = level
    end

    def on_complete
      events.trigger(:complete)
    end

    def level
      @level
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

    def parse_cached_duration(dur)
      milliseconds = 0
      dur.split(':').each_with_index {|value, index|
        case index
        when 0
          milliseconds += 1000 * 60 * 60 * value.to_i
        when 1
          milliseconds += 1000 * 60 * value.to_i
        else
          milliseconds += 1000 * value.to_i
        end
      }
      milliseconds
    end

  end
end
