require 'curses'

module Soundcloud2000
  module UI
    class Color
      PAIRS = {
        :white  => 0,
        :red    => 1,
        :blue   => 2,
      }

      DEFINITION = {
        PAIRS[:white] => [ Curses::COLOR_WHITE, Curses::COLOR_BLACK ],
        PAIRS[:red]   => [ Curses::COLOR_RED,   Curses::COLOR_WHITE ],
        PAIRS[:blue]  => [ Curses::COLOR_BLUE,  Curses::COLOR_WHITE ],
      }

      COLORS = {
        :white => Curses.color_pair(PAIRS[:white]),
        :black => Curses.color_pair(PAIRS[:white])|Curses::A_REVERSE,
        :red   => Curses.color_pair(PAIRS[:red]),
        :blue  => Curses.color_pair(PAIRS[:blue]),
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
