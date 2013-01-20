require_relative 'controller'
require_relative '../time_helper'
require_relative '../ui/table'

module Soundcloud2000
  module Controllers
    class TrackController < Controller

      def initialize(client, x = 0, y = 0)
        super

        @page = 1
        @client = client
        @tracks = load_tracks(@page)
        @table = initialize_table(x, y)

        events.on(:key) do |key|
          case key
          when :enter
            @table.select
            events.trigger(:select, @tracks[@table.current])
          when :up
            @table.up
          when :down
            @table.down

            if @table.bottom?
              @tracks += load_tracks(@page += 1)
              @table.body(*tracks)
            end
          end
        end
      end

    protected

      def tracks
        @tracks.map { |track| [ track.title, track.user.username, TimeHelper.duration(track.duration) ] }
      end

      def initialize_table(x, y)
        table = UI::Table.new(Curses.lines, Curses.cols, x, y)
        table.header 'Title', 'User', 'Length'
        table.body *tracks

        table
      end

      def load_tracks(page)
        @client.tracks(page)
      end

    end
  end
end
