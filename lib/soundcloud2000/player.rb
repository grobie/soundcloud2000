require 'audite'
require_relative 'download_thread'

module Soundcloud2000
  class Player
    attr_reader :track, :events

    def initialize(logger)
      @logger = logger
      @track = nil
      @events = Events.new
      @folder = File.expand_path("~/.soundcloud2000")
      @seek_speed = {}
      @seek_time = {}

      Dir.mkdir(@folder) unless File.exist?(@folder)
    end

    def create_player
      player = Audite.new
      player.events.on(:position_change) do |position|
        events.trigger(:progress)
      end

      player.events.on(:level) do |level|
        @level = level
      end

      player.events.on(:complete) do
        events.trigger(:complete)
      end

      player
    end

    def play(track, location)
      log :play, track.id
      @track = track
      load(track, location)
      start
    end

    def play_progress
      seconds_played / duration
    end

    def duration
      @track.duration.to_f / 1000
    end

    def title
      [@track.title, @track.user.username].join(' - ')
    end

    def length_in_seconds
      mpg = Mpg123.new(@file)
      mpg.length * mpg.tpf / mpg.spf
    end

    def load(track, location, &block)
      @file = "#{@folder}/#{track.id}.mp3"

      if !File.exist?(@file) || track.duration / 1000 < length_in_seconds * 0.95
        File.unlink(@file) rescue nil
        @download = DownloadThread.new(@logger, location, @file)
      else
        @download = nil
      end

      @player ||= create_player
      @player.load(@file)
    end

    def log(*args)
      @logger.debug 'Player: ' + args.join(" ")
    end

    def level
      @level.to_f
    end

    def seconds_played
      @player.position
    end

    def download_progress
      if @download
        @download.progress / @download.total.to_f
      else
        1
      end
    end

    def playing?
      @player.active
    end


    def seek_speed(direction)
      if @seek_time[direction] && Time.now - @seek_time[direction] < 0.5
        @seek_speed[direction] *= 1.05
      else
        @seek_speed[direction] = 1
      end

      @seek_time[direction] = Time.now
      @seek_speed[direction]
    end

    def rewind
      @player.rewind(seek_speed(:rewind)) if @player
    end

    def forward
      seconds = seek_speed(:forward)

      if @player && ((seconds + seconds_played) / duration) < download_progress
        @player.forward(seconds)
      end
    end

    def stop
      @player.stop_stream if @player
    end

    def start
      @player.start_stream if @player
    end

    def toggle
      @player.toggle if @player
    end

  end
end
