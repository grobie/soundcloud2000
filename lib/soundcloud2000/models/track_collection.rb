require_relative 'collection'
require_relative 'track'
require_relative 'playlist'

module Soundcloud2000
  module Models
    class TrackCollection < Collection
      DEFAULT_LIMIT = 50

      attr_reader :limit
      attr_accessor :collection_to_load, :user, :playlist

      def initialize(client)
        super
        @limit = DEFAULT_LIMIT
        @collection_to_load = :recent
      end

      def size
        @rows.size
      end

      def clear_and_replace
        clear
        load_more
        events.trigger(:replace)
      end

      def load
        clear
        load_more
      end

      def load_more
        unless @loaded
          tracks = self.send(@collection_to_load.to_s + "_tracks")
          @loaded = true if tracks.empty?
          append tracks.map {|hash| Track.new hash }
          @page += 1
        end
      end

      def favorites_tracks
        @client.get(@user.uri + '/favorites', offset: @limit * @page, limit: @limit)
      end

      def recent_tracks
        @client.get('/tracks', offset: @page * limit, limit: @limit)
      end

      def user_tracks
        @client.get(@user.uri + '/tracks', offset: @limit * @page, limit: @limit)
      end

      def playlist_tracks
        @client.get(@playlist.uri + '/tracks', offset: @limit * @page, limit: @limit)
      end

    end
  end
end
