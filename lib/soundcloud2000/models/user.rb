module Soundcloud2000
  module Models
    class User

      def initialize(hash)
        @hash = hash
      end

      def id
        @hash['id']
      end

      def username
        @hash['username']
      end

      def uri
        @hash['uri']
      end

      def permalink
        @hash['permalink']
      end
    end
  end
end
