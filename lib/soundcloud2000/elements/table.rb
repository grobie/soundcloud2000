require_relative 'element'

module Soundcloud2000
  module Elements
    class Table < Element
      ROW_SEPARATOR = ?|
      LINE_SEPARATOR = ?-

      def initialize(height = Curses.lines, width = Curses.cols, x = 0, y = 0)
        @height, @width, @x, @y = height, width, x, y
        @window = Curses::Window.new(@height, @width, @x, @y)
        @window.keypad = true

        reset
      end

      def width
        @width
      end

      def header(*elements)
        @header = elements
      end

      def body(*rows)
        @rows = rows
      end

      def reset
        @row = 0
        @window.clear
        @window.box(ROW_SEPARATOR, LINE_SEPARATOR, ?+)
      end

      def draw
        reset
        draw_header
        draw_body
        @window.refresh
        @window.getch
      end

    protected

      def draw_header
        if @header
          draw_row(@header.join(' '))
          draw_row(LINE_SEPARATOR * (width - 3), 0)
        end
      end

      def draw_body
        @rows.each do |row|
          draw_row(row.join(' '))
        end
      end

      def draw_row(content, padding = 1)
        @window.setpos(@row += 1, padding + 2)
        @window.addstr(content)
      end

    end
  end
end
