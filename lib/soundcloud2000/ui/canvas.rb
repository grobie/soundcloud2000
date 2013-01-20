require 'curses'

require_relative 'color'

module Soundcloud2000
  module UI
    class Canvas

      def initialize
        Curses.noecho # do not show typed keys
        Curses.stdscr.keypad(true) # enable arrow keys
        Curses.init_screen
        Color.init
      end

      def close
        Curses.close_screen
      end

    end
  end
end
