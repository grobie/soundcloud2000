require_relative 'controller'
require_relative '../player'
require_relative '../ui/player'

module Soundcloud2000
  module Controllers
    class PlayerController < Controller

      def initialize(logger, client, h, w, x, y)
        super

        @logger = logger
        @client = client
        @player = Player.new(@logger)

        @view = UI::Player.new(h, w, x, y)
        @view.player(@player)

        events.on(:key) do |key|
          case key
          when :left then  @player.rewind
          when :right then @player.forward
          when :space
            @player.toggle
            @view.render
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
