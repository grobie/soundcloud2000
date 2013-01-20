require_relative '../ui/view'
require_relative '../events'
require_relative '../../audio_player/player'
require 'net/http'

module Soundcloud2000
  module Controllers
    class PlayerController
      def initialize(client, h, w, x, y)
        @client = client
        @events = Events.new
        @view = UI::View.new(h, w, x, y)
        @player = AudioPlayer::Player.new
      end

      def play(track)
        uri = URI.parse(track.stream_url + '?client_id=' + @client.client_id)
        Net::HTTP.get_response(uri) do |res|
          if res.code == '302'
            @player.load(res.header['Location'], track.id)
            @player.start
          end
        end
      end
    end
  end
end
