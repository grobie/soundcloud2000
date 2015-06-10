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
          when :up, :k
            @view.up
          when :down, :j
            @view.down
            @tracks.load_more if @view.bottom?
          when :u
            user = fetch_user_with_message('Change to SoundCloud user: ')
            if user[:success]
              @tracks.user = @client.current_user = user[:user]
              @tracks.collection_to_load = :user
              @tracks.clear_and_replace
            else
              UI::Input.error("No such user '#{user[:user]}'. Use u to try again.")
            end
          when :f
            @client.current_user = fetch_user_with_message('Change to SoundCloud user: ') if @client.current_user.nil?
            @tracks.collection_to_load = :favorites
            @tracks.clear_and_replace
          when :s
            @view.clear
            @client.current_user = fetch_user_with_message('Change to SoundCloud user: ') if @client.current_user.nil?
            set = UI::Input.getstr('Change to SoundCloud playlist: ')
            set_request = @client.resolve(@client.current_user.permalink + '/sets/' + set)
            unless set_request == nil
              @tracks.playlist = Models::Playlist.new(set_request)
              @tracks.collection_to_load = :playlist
              @tracks.clear_and_replace
            else
              UI::Input.error("No such set/playlist '#{set}' for #{@client.current_user.username}")
            end
          end
        end
      end

      def fetch_user_with_message(message_to_display)
        permalink = UI::Input.getstr(message_to_display)
        user_hash = @client.resolve(permalink)
        if user_hash
          { success: true,
            user: Models::User.new(user_hash) }
        else
          { success: false,
            user: permalink }
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
