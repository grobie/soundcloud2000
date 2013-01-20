require_relative '../ui/view'
require_relative '../events'
require_relative '../../audio_player/player'
require 'net/http'

module Soundcloud2000
  module Controllers
    class PlayerController
      attr_reader :events

      def initialize(logger, client, h, w, x, y)
        @logger = logger
        @client = client
        @events = Events.new
        @view = UI::View.new(h, w, x, y)
        @player = AudioPlayer::Player.new(@logger)
        @events.on(:key) do |key|
          case key
          when :left then @player.rewind
          when :right then @player.forward
          when :space then @player.toggle
          end
        end
      end

      def play(track)
        uri = URI.parse(track.stream_url + '?client_id=' + @client.client_id)
        Net::HTTP.get_response(uri) do |res|
          if res.code == '302'
            load res.header['Location'], track
          end
        end
      end

      def load(url, track)
        @player.load(url, track.id) do |pos, size|
          col = (pos * @view.width / size).to_i
          @view.render do
            @view.window.setpos(0, 5)
            @view.window.addstr(('-' * col + '>').ljust(@view.width))
          end
        end
        @player.start
      end
    end
  end
end
