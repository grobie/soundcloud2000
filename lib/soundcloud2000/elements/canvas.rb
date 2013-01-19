require_relative 'element'

module Soundcloud2000
  module Elements
    class Canvas < Element

      def initialize
        Curses.noecho # do not show typed keys
        Curses.init_screen
        Curses.stdscr.keypad(true) # enable arrow keys

        @children = []
      end

      def add(child)
        @children << child
      end

      def draw
        @children.each do |child|
          child.draw if child.dirty?
        end
      end

      def close
        Curses.close_screen
      end

    end
  end
end
