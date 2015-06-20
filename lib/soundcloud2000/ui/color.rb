require 'curses'

module Soundcloud2000
  module UI
    # this class stores our text color configurations
    class Color
      PAIRS = {
        white: 0,
        red:   1,
        blue:  2,
        green: 3,
        cyan:  4
      }

      DEFINITION = {
        PAIRS[:white] => [Curses::COLOR_WHITE, Curses::COLOR_BLACK],
        PAIRS[:red]   => [Curses::COLOR_RED,   Curses::COLOR_BLACK],
        PAIRS[:blue]  => [Curses::COLOR_BLUE,  Curses::COLOR_WHITE],
        PAIRS[:green] => [Curses::COLOR_GREEN, Curses::COLOR_BLACK],
        PAIRS[:cyan]  => [Curses::COLOR_BLACK, Curses::COLOR_CYAN]
      }

      COLORS = {
        white: Curses.color_pair(PAIRS[:white]),
        black: Curses.color_pair(PAIRS[:white]) | Curses::A_REVERSE,
        red:   Curses.color_pair(PAIRS[:red]),
        blue:  Curses.color_pair(PAIRS[:blue]),
        green: Curses.color_pair(PAIRS[:green]),
        green_reverse: Curses.color_pair(PAIRS[:green]) | Curses::A_REVERSE,
        cyan:  Curses.color_pair(PAIRS[:cyan])
      }

      def self.init
        Curses.start_color

        DEFINITION.each do |definition, (color, background)|
          Curses.init_pair(definition, color, background)
        end
      end

      def self.get(name)
        COLORS[name]
      end
    end
  end
end
