require_relative 'collection'
require_relative 'track'
require_relative 'playlist'

module Soundcloud2000
  module Models
    # This model deals with the different types of tracklists that populate
    # the tracklist section
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
          tracks = send(@collection_to_load.to_s + '_tracks')
          @loaded = true if tracks.empty?
          append tracks.map { |hash| Track.new hash }
          @page += 1
        end
      end

      def favorites_tracks
        return [] if @client.current_user.nil?
        @client.get(@client.current_user.uri + '/favorites', offset: @limit * @page, limit: @limit)
      end

      def recent_tracks
        @client.get('/tracks', offset: @page * limit, limit: @limit)
      end

      def user_tracks
        return [] if @client.current_user.nil?
        user_tracks = @client.get(@client.current_user.uri + '/tracks', offset: @limit * @page, limit: @limit)
        if user_tracks.empty?
          UI::Input.error("'#{@client.current_user.username}' has not authored any tracks. Use f to switch to their favorites, or s to switch to their playlists.")
          return []
        else
          return user_tracks
        end
      end

      def playlist_tracks
        return [] if @playlist.nil?
        @client.get(@playlist.uri + '/tracks', offset: @limit * @page, limit: @limit)
      end
    end
  end
end
