require_relative 'controller'
require_relative '../time_helper'
require_relative '../ui/table'
require_relative '../ui/input'

module Soundcloud2000
  module Controllers
    class TrackController < Controller

      def initialize(client, x = 0, y = 0)
        super

        @page = 1
        @client = client
        @tracks = load_tracks(@page)
        @table = initialize_table(x, y)
        @loaded = false

        events.on(:key) do |key|
          case key
          when :enter
            @table.select
            events.trigger(:select, @tracks[@table.current])
          when :up
            @table.up
          when :down
            @table.down

            if @table.bottom? && more?
              @tracks += load_tracks(@page += 1)
              @table.body(*rows)
            end
          when :u
            new_user = UI::Input.getstr
            @tracks = @client.tracks_by_username(new_user)
            @table = initialize_table(x, y)
          end
        end
      end

      def render
        @table.render
      end

    protected

      def more?
        @loaded = true
      end

      def rows
        @tracks.map do |track|
          [
            track.title,
            track.user.username,
            TimeHelper.duration(track.duration),
            track.playback_count.to_s,
            track.favoritings_count.to_s,
            track.comment_count.to_s,
            # track.genre,
            # track.permalink_url,
          ]
        end
      end

      def initialize_table(x, y)
        table = UI::Table.new(Curses.lines, Curses.cols, x, y)
        table.header 'Title', 'User', 'Length', 'Plays', 'Likes', 'Comments'#, 'Genre', 'URL'
        table.body(*rows)

        table
      end

      def load_tracks(page)
        tracks = @client.tracks(page)
        @loaded = true if tracks.empty?
        tracks
      end

    end
  end
end
