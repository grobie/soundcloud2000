require_relative '../events'

module Soundcloud2000
  module Models
    class Collection
      include Enumerable
      attr_reader :events, :rows, :page

      def initialize(client)
        @client = client
        @events = Events.new
        clear
      end

      def [](*args)
        @rows[*args]
      end

      def clear
        @page = 0
        @rows = []
        @loaded = false
      end

      def each(&block)
        @rows.each(&block)
      end

      def replace(rows)
        clear
        @rows = rows
        events.trigger(:replace)
      end

      def append(rows)
        @rows += rows
        events.trigger(:append)
      end
    end
  end
end
