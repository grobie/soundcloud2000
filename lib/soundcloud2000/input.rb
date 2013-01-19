require 'curses'

module Soundcloud2000
  class Input

    def self.get(delay = 0)
      Curses.timeout = delay
      case Curses.getch
      when Curses::KEY_DOWN
        :down
      when Curses::KEY_UP
        :up
      end
    end

  end
end
