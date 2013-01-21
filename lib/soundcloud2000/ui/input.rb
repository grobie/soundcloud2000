require 'curses'

module Soundcloud2000
  module UI
    class Input
      MAPPING = {
        Curses::KEY_LEFT   => :left,
        Curses::KEY_RIGHT  => :right,
        Curses::KEY_DOWN   => :down,
        Curses::KEY_UP     => :up,
        Curses::KEY_CTRL_J => :enter,
        Curses::KEY_ENTER  => :enter,
        ' '                => :space,
        'u'                => :u
      }

      def self.get(delay = 0)
        Curses.timeout = delay
        MAPPING[Curses.getch]
      end

      def self.getstr()
        Curses.getstr
      end

    end
  end
end
