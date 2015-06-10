require_relative 'controller'
require_relative '../models/player'
require_relative '../views/player_view'

module Soundcloud2000
  module Controllers
    class PlayerController < Controller

      def initialize(view, client)
        super(view)

        @client = client
        @player = Models::Player.new

        @player.events.on(:progress) do
          @view.render
        end

        @player.events.on(:complete) do
          events.trigger(:complete)
        end

        @view.player(@player)

        events.on(:key) do |key|
          if @player.playing?
            case key
            when :left
              @player.rewind
            when :right
              @player.forward
            when :one
              @player.seek_position(1)
            when :two
              @player.seek_position(2)
            when :three
              @player.seek_position(3)
            when :four
              @player.seek_position(4)
            when :five
              @player.seek_position(5)
            when :six
              @player.seek_position(6)
            when :seven
              @player.seek_position(7)
            when :eight
              @player.seek_position(8)
            when :nine
              @player.seek_position(9)
            end
          end
          if key == :space
            if @player.track
              @player.toggle
              @view.render
            end
          end
        end
      end

      def play(track)
        unless track == nil
          location = @client.location(track.stream_url)
          @player.play(track, location)
        else
          UI::Input.error("No track currently selected. Use f to switch to #{@client.current_user.username}'s favorites, or s to switch to their playlists/sets.")
        end
      end

    end
  end
end
