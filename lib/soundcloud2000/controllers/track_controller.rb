require_relative '../ui/table'
require_relative '../events'
require_relative '../time_helper'

module Soundcloud2000
  module Controllers
    class TrackController
      attr_reader :table, :events

      def initialize(client, x = 0, y = 0)
        @events = Events.new
        @page = 1
        @client = client
        @tracks = load_tracks(@page)

        @table = initialize_table(x, y)
        @table.events.on(:key) do |key|
          case key
          when :enter
            @events.trigger(:select, @tracks[@table.current])
          when :down
            if @table.current + 1 >= @table.length
              @tracks += load_tracks(@page += 1)
              @table.body(*tracks)
            end
          end
        end
      end

      def tracks
        @tracks.map { |track| [ track.title, track.user.username, TimeHelper.duration(track.duration) ] }
      end

    protected

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
