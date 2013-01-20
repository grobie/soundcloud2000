require_relative '../events'

module Soundcloud2000
  module Controllers
    class Controller
      attr_reader :events

      def initialize(*args)
        @events = Events.new
      end

    end
  end
end
