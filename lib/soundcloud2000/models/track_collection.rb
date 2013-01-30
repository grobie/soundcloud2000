require_relative 'collection'
require_relative 'track'

module Soundcloud2000
  module Models
    class TrackCollection < Collection
      DEFAULT_LIMIT = 50

      attr_reader :limit, :user

      def initialize(client)
        super
        @limit = DEFAULT_LIMIT
      end

      def size
        @rows.size
      end

      def user=(user)
        @user = user
        load
        events.trigger(:replace)
      end

      def load
        clear
        load_more
      end

      def load_more
        unless @loaded
          tracks = user ? user_tracks : recent_tracks
          @loaded = true if tracks.empty?
          append tracks.map {|hash| Track.new hash }
          @page += 1
        end
      end

      def recent_tracks
        @client.get('/tracks', offset: @page * limit, limit: @limit)
      end

      def user_tracks
        @client.get(@user.uri + '/tracks', offset: @limit * @page, limit: @limit)
      end
    end
  end
end
