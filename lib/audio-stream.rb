$:.unshift File.dirname(__FILE__)

require "audio_player/player"

player = AudioPlayer::Player.new
player.load("http://233music.com//media/downloads/Tony%20Harmony%20-%20Happy%20Birthday%20ft.%20SK%20Original%20(www.233music.com).mp3", "01.mp3")

require 'curses'
Curses.noecho # do not show typed keys
Curses.init_screen
Curses.stdscr.keypad(true) # enable arrow keys
Curses.timeout = 10

loop do
  c = Curses.getch
  case c
  when ' '
    player.toggle
  when Curses::KEY_LEFT
    player.rewind
  when Curses::KEY_RIGHT
    player.forward
  end
end
