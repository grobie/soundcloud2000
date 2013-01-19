require 'curses'

module Soundcloud2000
  class Application

    def initialize
      Curses.noecho # do not show typed keys
      Curses.init_screen
      Curses.stdscr.keypad(true) # enable arrow keys
    end

    def run
      loop do
        yield
      end
    ensure
      Curses.close_screen
    end

  end
end
