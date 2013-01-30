require_relative 'view'

module Soundcloud2000
  module UI
    class Table < View
      SEPARATOR = '  |  '

      attr_reader :current, :collection
      attr_accessor :header, :keys

      def initialize(*args)
        super

        @sizes = []
        @rows = []
        @current, @top = 0, 0
        @selected = nil

        reset
      end

      def bind_to(collection)
        raise ArgumentError if @collection

        @collection = collection
        @collection.events.on(:append) { render }
        @collection.events.on(:replace) { clear; render }
      end

      def length
        @collection.size
      end

      def body_height
        rect.height - @header.size
      end

      def bottom?
        current + 1 >= length
      end

      def up
        if @current > 0
          @current -= 1
          @top -= 1 if @current < @top
          render
        end
      end

      def down
        if (@current + 1) < length
          @current += 1
          @top += 1 if @current > body_height
          render
        end
      end

      def select
        @selected = @current
        render
      end

      def deselect
        @selected = nil
        render
      end

    protected

      def rows(start = 0, size = collection.size)
        collection[start, size].map do |record|
          keys.map {|key| record.send(key).to_s }
        end
      end

      def rest_width(elements)
        rect.width - elements.size * SEPARATOR.size -
          elements.inject(0) { |sum, size| sum += size }
      end

      def perform_layout
        @sizes = []
        (rows + [header]).each do |row|
          row.each_with_index do |value, index|
            current, max = value.to_s.length, @sizes[index] || 0
            @sizes[index] = current if max < current
          end
        end

        @sizes[-1] = rest_width(@sizes[0...-1])
      end

      def draw
        draw_header
        draw_body
      end

      def draw_header
        with_color(:green_reverse) do
          draw_values(header)
        end
      end

      def color_for(index)
        if @top + index == @current
          :cyan
        elsif @top + index == @selected
          :black
        else
          :white
        end
      end

      def draw_body
        rows(@top, body_height + 1).each_with_index do |row, index|
          with_color(color_for(index)) do
            draw_values(row)
          end
        end
      end

      def draw_values(values)
        i = -1
        content = values.map { |value| value.ljust(@sizes[i += 1]) }.join(SEPARATOR)

        line content
      end

    end
  end
end
