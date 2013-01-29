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

    end
  end
end
