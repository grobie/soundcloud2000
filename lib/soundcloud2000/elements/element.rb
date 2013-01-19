require 'curses'

module Soundcloud2000
  module Elements
    class Element
      COLORS = {
        :red  => Curses::COLOR_RED,
        :blue => Curses::COLOR_BLUE,
      }

      def initialize(*args)
        @fresh = false
        # TODO: don't initialize all the time
        # Curses.start_color
        # Curses.init_pair(Curses::COLOR_BLUE, Curses::COLOR_BLUE,  Curses::COLOR_WHITE)
        # Curses.init_pair(Curses::COLOR_RED,  Curses::COLOR_RED,   Curses::COLOR_WHITE)
      end

      def fresh?
        @fresh == true
      end

      def refresh
        @fresh = true
      end

      def color(name)
        Curses.color_pair(COLORS[name])
      end

      def height
        @height
      end

      def width
        @width
      end

    end
  end
end