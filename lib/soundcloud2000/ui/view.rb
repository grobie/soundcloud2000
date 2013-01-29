require 'curses'

require_relative 'color'

module Soundcloud2000
  module UI
    class View
      ROW_SEPARATOR = ?|
      LINE_SEPARATOR = ?-
      INTERSECTION = ?+

      attr_reader :rect

      def initialize(rect)
        @rect = rect
        @window = Curses::Window.new(rect.height, rect.width, rect.y, rect.x)
        @line = 0
        @padding = 0
      end

      def padding(value = nil)
        value.nil? ? @padding : @padding = value
      end

      def render
        perform_layout
        reset
        draw
        refresh
      end

      def body_width
        rect.width - 2 * padding
      end

      def with_color(name, &block)
        @window.attron(Color.get(name), &block)
      end

      def clear
        @window.clear
      end

    protected

      def lines_left
        rect.height - @line - 1
      end

      def line(content)
        @window.setpos(@line, padding)
        @window.addstr(content.ljust(body_width).slice(0, body_width))
        @line += 1
      end

      def reset
        @line = 0
      end

      def refresh
        @window.refresh
      end

      def perform_layout
      end

      def draw
        raise NotImplementedError
      end

    end
  end
end
