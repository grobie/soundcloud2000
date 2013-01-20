require_relative '../ui/player'
require_relative '../events'
require_relative '../player'

module Soundcloud2000
  module Controllers
    class PlayerController
      attr_reader :events

      def initialize(logger, client, h, w, x, y)
        @logger = logger
        @client = client
        @events = Events.new
        @player = Player.new(@logger)

        @view = UI::Player.new(h, w, x, y)
        @view.player(@player)

        @events.on(:key) do |key|
          case key
          when :left then @player.rewind
          when :right then @player.forward
          when :space then @player.toggle
          end
        end
      end

      def play(track)
        location = @client.location(track.stream_url)

        @player.play(track, location) do
          @view.render
        end
      end

    end
  end
end
