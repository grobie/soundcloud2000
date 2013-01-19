require 'curses'

module Soundcloud2000
  module Elements
    class Color
      COLORS = {
        :white  => 0,
        :red    => 1,
      }

      DEFINITION = {
        COLORS[:white] => [ Curses::COLOR_WHITE, Curses::COLOR_BLACK ],
        COLORS[:red]   => [ Curses::COLOR_RED,   Curses::COLOR_WHITE ],
      }

      def self.init
        Curses.start_color

        DEFINITION.each do |definition, (color, background)|
          Curses.init_pair(definition, color, background)
        end
      end

      def self.get(name, inverse = false)
        color = Curses.color_pair(COLORS[name])
        color |= Curses::A_REVERSE if inverse
        color
      end

    end
  end
end
