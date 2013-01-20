require_relative 'view'

module Soundcloud2000
  module UI
    class Table < View
      PADDING = 1

      attr_reader :current

      def initialize(*args)
        super

        @sizes = []
        @rows = []
        @current, @top = 0, 0

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

      def length
        @rows.size
      end

      def body_height
        height - Array(@header).size
      end

      def up
        if @current > 0
          @current -= 1
          @top -= 1 if @current < @top
          draw

          true
        else
          false
        end
      end

      def down
        if (@current + 1) < length
          @current += 1
          @top += 1 if @current > body_height
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
          color(:blue) do
            draw_values(@header)
          end
        end
      end

      def draw_body
        @rows[@top, body_height + 1].each_with_index do |row, index|
          color(:white, @top + index == @current ? :inverse : nil) do
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
