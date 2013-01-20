require_relative 'widget'

module Soundcloud2000
  module UI
    class Table < Widget
      PADDING = 1

      attr_reader :current

      def initialize(*args)
        super

        @sizes = []
        @rows = []
        @current = 0

        events.on(:key) do |key|
          case key
          when :up then up
          when :down then down
          end
        end

        reset
      end

      def header(*elements)
        @header = elements
        @header
      end

      def body(*rows)
        @rows = rows
        calculate_widths
        @rows
      end

      def up
        if @current > 0
          @current -= 1
          draw

          true
        else
          false
        end
      end

      def length
        @rows.size
      end

      def down
        if (@current + 1) < length
          @current += 1
          draw

          true
        else
          false
        end
      end

      def reset
        super
        @row = 0
      end

      def draw
        render do
          draw_header
          draw_body
        end
      end

    protected

      def calculate_widths
        @rows.each do |row|
          row.each_with_index do |value, index|
            current, max = value.length, @sizes[index] || 0
            @sizes[index] = current if max < current
          end
        end

        draw
      end

      def draw_header
        if @header
          draw_values(@header)
          draw_line
        end
      end

      def draw_body
        @rows.each_with_index do |row, index|
          color(:white, index == @current ? :inverse : nil) do
            draw_values(row)
          end
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
