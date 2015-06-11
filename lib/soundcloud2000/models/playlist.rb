module Soundcloud2000
  module Models
    class Playlist

      def initialize(hash)
        @hash = hash
      end

      def id
        @hash['id']
      end

      def title
        @hash['title']
      end

      def uri
        @hash['uri']
      end

    end
  end
end
