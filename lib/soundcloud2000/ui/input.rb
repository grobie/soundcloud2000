require 'curses'

module Soundcloud2000
  module UI
    class Input
      MAPPING = {
        Curses::KEY_DOWN  => :down,
        Curses::KEY_UP    => :up,
        Curses::KEY_ENTER => :enter,
      }

      def self.get(delay = 0)
        Curses.timeout = delay
        MAPPING[Curses.getch]
      end

    end
  end
end
