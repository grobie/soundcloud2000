require_relative 'user'

module Soundcloud2000
  module Models
    class Track

      def initialize(hash)
        @hash = hash
      end

      def id
        @hash['id']
      end

      def title
        @hash['title']
      end

      def url
        @hash['permalink_url']
      end

      def user
        @user ||= User.new(@hash['user'])
      end

      def username
        user.username
      end

      def duration
        @hash['duration']
      end

      def length
        TimeHelper.duration(duration)
      end

      def plays
        @hash['playback_count']
      end

      def likes
        @hash['favoritings_count']
      end

      def comments
        @hash['comments']
      end

      def stream_url
        @hash['stream_url']
      end

    end
  end
end
