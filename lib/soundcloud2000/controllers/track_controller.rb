require_relative 'controller'
require_relative '../time_helper'
require_relative '../ui/table'
require_relative '../ui/input'
require_relative '../models/track_collection'
require_relative '../models/user'

module Soundcloud2000
  module Controllers
    class TrackController < Controller

      def initialize(view, client)
        super(view)

        @client = client

        events.on(:key) do |key|
          case key
          when :enter
            @view.select
            events.trigger(:select, current_track)
          when :up
            @view.up
          when :down
            @view.down
            @tracks.load_more if @view.bottom?
          when :u
            permalink = UI::Input.getstr('Change to SoundCloud user: ')
            @tracks.user = Models::User.new(@client.resolve(permalink))
          end
        end
      end

      def current_track
        @tracks[@view.current]
      end

      def bind_to(tracks)
        @tracks = tracks
        @view.bind_to(tracks)
      end

      def load
        @tracks.load
      end

      def next_track
        @view.down
        @view.select
        events.trigger(:select, current_track)
      end

    end
  end
end
