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

    end
  end
end
