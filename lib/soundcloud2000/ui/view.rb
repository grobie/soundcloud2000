require 'curses'

require_relative 'color'

module Soundcloud2000
  module UI
    class View
      ROW_SEPARATOR = ?|
      LINE_SEPARATOR = ?-
      INTERSECTION = ?+

      attr_reader :height, :width, :x, :y
      attr_reader :window

      def initialize(height = Curses.lines, width = Curses.cols, x = 0, y = 0)
        @height, @width, @x, @y = height - x, width - y, x, y
        @window = Curses::Window.new(height, width, x, y)
        @line = 0
      end

      def render
        reset
        draw
        refresh
      end

      def color(name, inverse = nil, &block)
        window.attron(Color.get(name, inverse), &block)
      end

    protected

      def reset
        @line = 0
      end

      def refresh
        window.refresh
      end

      def draw
        raise NotImplementedError
      end

    end
  end
end
