require_relative '../audio_player/player'

module Soundcloud2000
  class Player
    attr_reader :track, :events

    def initialize(logger)
      @logger = logger
      @track = nil
      @events = Events.new
      @audio = AudioPlayer::Player.new(@logger)
      @audio.events.on(:progress) do
        events.trigger(:progress)
      end
    end

    def play(track, location)
      @track = track
      @audio.load(location)
      @audio.start

      @logger.debug @track.to_json
    end

    [:toggle, :playing?, :rewind, :forward, :seconds_played, :spectrum].each do |name|
      define_method(name) { @audio.send(name) }
    end

    def play_progress
      @audio.seconds_played / (@track.duration / 1000)
    end

    def title
      [@track.title, @track.user.username].join(' - ')
    end

  end
end
