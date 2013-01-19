require_relative 'element'

module Soundcloud2000
  module Elements
    class Table < Element
      ROW_SEPARATOR = ?|
      LINE_SEPARATOR = ?-
      INTERSECTION = ?+
      PADDING = 1

      def initialize(height = Curses.lines, width = Curses.cols, x = 0, y = 0)
        super
        @height, @width, @x, @y = height, width, x, y
        @window = Curses::Window.new(@height, @width, @x, @y)
        @sizes = []
        @rows = []

        reset
      end

      def header(*elements)
        @header = elements
        calculate_widths
        @header
      end

      def body(*rows)
        @rows = rows
        calculate_widths
        @rows
      end

      def reset
        @row = 0
        @window.clear
        @window.box(ROW_SEPARATOR, LINE_SEPARATOR, INTERSECTION)
      end

      def refresh
        super
        @window.refresh
      end

      def draw
        reset
        draw_header
        draw_body
        refresh
      end

    protected

      def calculate_widths
        @rows.each do |row|
          row.each_with_index do |value, index|
            current, max = value.length, @sizes[index] || 0
            @sizes[index] = current if max < current
          end
        end
      end

      def draw_header
        if @header
          draw_values(@header)
          draw_line
        end
      end

      def draw_body
        @rows.each do |row|
          draw_values(row)
        end
      end

      def draw_line
        draw_content(INTERSECTION + LINE_SEPARATOR * (width - 2) + INTERSECTION, 0)
      end

      def draw_values(values, padding = PADDING)
        space = ' ' * [padding, 0].max
        i = -1
        draw_content(values.map { |value| value.ljust(@sizes[i += 1]) }.join(space))
      end

      def draw_content(content, start = 2)
        @window.setpos(@row += 1, start)
        @window.addstr(content)
      end

    end
  end
end
