require_relative '../time_helper'

module Soundcloud2000
  module UI
    class Player < View

      def initialize(*attrs)
        super

        @spectrum = true
        padding 2
      end

      def player(instance)
        @player = instance
      end

      def toggle_spectrum
        @spectrum = !@spectrum
      end

    protected

      def draw
        line progress + download_progress
        with_color(:green) do
          line (duration + ' - ' + status).ljust(16) + @player.title
        end
        line track_info
        line '>' * (@player.level.to_f * body_width).ceil
      end

      def status
        @player.playing? ? 'playing' : 'paused'
      end

      def progress
        '#' * (@player.play_progress * body_width).ceil
      end

      def download_progress
        progress = @player.download_progress - @player.play_progress

        if progress > 0
          '.' * (progress * body_width).ceil
        else
          ''
        end
      end

      def track
        @player.track
      end

      def track_info
        "#{track.playback_count} Plays | #{track.favoritings_count} Likes | #{track.comment_count} Comments | #{track.permalink_url}"
      end

      def duration
        TimeHelper.duration(@player.seconds_played.to_i * 1000)
      end

    end
  end
end
