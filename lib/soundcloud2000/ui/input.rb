require 'curses'
require_relative 'color'

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
        'j'                => :j,
        'k'                => :k,
        's'                => :s,
        'u'                => :u,
        '1'                => :one,
        '2'                => :two,
        '3'                => :three,
        '4'                => :four,
        '5'                => :five,
        '6'                => :six,
        '7'                => :seven,
        '8'                => :eight,
        '9'                => :nine,
        'f'                => :f
      }

      def self.get(delay = 0)
        Curses.timeout = delay
        MAPPING[Curses.getch]
      end

      def self.getstr(prompt)
        Curses.setpos(Curses.lines - 1, 0)
        Curses.addstr(prompt)
        Curses.echo
        result = Curses.getstr
        Curses.noecho
        Curses.setpos(Curses.lines - 1, 0)
        Curses.addstr(''.ljust(Curses.cols))
        result
      end

      def self.input_line_out(output)
        Curses.setpos(Curses.lines - 1, 0)
        Curses.attron(Color.get(:red)) { Curses.addstr(output) }
        Curses.echo
      end
    end
  end
end
