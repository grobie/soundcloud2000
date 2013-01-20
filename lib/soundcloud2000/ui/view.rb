require 'curses'

require_relative 'color'

module Soundcloud2000
  module UI
    class View
      ROW_SEPARATOR = ?|
      LINE_SEPARATOR = ?-
      INTERSECTION = ?+

      attr_reader :height, :width, :x, :y

      def initialize(height = Curses.lines, width = Curses.cols, x = 0, y = 0)
        @height, @width, @x, @y = height - x, width - y, x, y
        @window = Curses::Window.new(height, width, x, y)
        @line = 0
        @padding = 0
      end

      def padding(value = nil)
        value.nil? ? @padding : @padding = value
      end

      def render
        reset
        draw
        refresh
      end

      def body_width
        width - 2 * padding
      end

      def with_color(name, &block)
        @window.attron(Color.get(name), &block)
      end

    protected

      def line_number
        @line += 1
      end

      def lines_left
        height - line_number - 1
      end

      def line(content)
        @window.setpos(line_number, padding)
        @window.addstr(content.ljust(body_width).slice(0, body_width))
      end

      def reset
        @line = 0
      end

      def refresh
        @window.refresh
      end

      def draw
        raise NotImplementedError
      end

    end
  end
end
