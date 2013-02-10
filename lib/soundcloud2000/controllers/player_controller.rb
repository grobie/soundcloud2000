require_relative 'controller'
require_relative '../models/player'
require_relative '../views/player_view'

module Soundcloud2000
  module Controllers
    class PlayerController < Controller

      def initialize(view, client, logger)
        super(view)

        @client = client
        @player = Models::Player.new(logger)

        @player.events.on(:progress) do
          @view.render
        end

        @player.events.on(:complete) do
          events.trigger(:complete)
        end

        @view.player(@player)

        events.on(:key) do |key|
          case key
          when :left
            @player.rewind
          when :right
            @player.forward
          when :space
            if @player.track
              @player.toggle
              @view.render
            end
          when :s
              @view.toggle_spectrum
          end
        end
      end

      def play(track)
        location = @client.location(track.stream_url)

        @player.play(track, location)
      end

    end
  end
end
