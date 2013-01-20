module Soundcloud2000
  module UI
    class Player < View

      def initialize(*attrs)
        super
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
        @window.setpos(@line += 1, 0)
        @window.addstr(('-' * @player.play_progress.ceil + '>' + "#{@player.play_progress.inspect}").ljust(width))
      end

      def draw_meta
        @window.setpos(@line += 1, 0)
        @window.addstr(@player.title)
      end

    end
  end
end
