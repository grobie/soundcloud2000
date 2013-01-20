module Soundcloud2000
  module UI
    class Player < View

      def initialize(*attrs)
        super

        padding 2
      end

      def player(instance)
        @player = instance
      end

    protected

      def draw
        draw_progress
        draw_meta
      end

      def draw_progress
        line '#' * (@player.play_progress * body_width).ceil
        line @player.play_progress.inspect.ljust(body_width)
      end

      def draw_meta
        line @player.title
      end

    end
  end
end
