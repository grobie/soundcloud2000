require_relative 'ui/canvas'
require_relative 'ui/input'
require_relative 'controllers/track_controller'
# require_relative 'controllers/player_controller'

module Soundcloud2000
  class Application

    def initialize(client)
      @canvas = UI::Canvas.new
      # @player_controller = Views::PlayerView.new
      @track_controller = Controllers::TrackController.new(client, 10)
      @track_controller.events.on(:select) do |track|
        # @player_controller.play(track)
      end
    end

    def run
      loop do
        handle UI::Input.get(100)
        break if stop?
      end
    ensure
      @canvas.close
    end

    # TODO: look at active panel and send key to active panel instead
    def handle(key)
      case key
      when :down, :up, :enter
        # HACK. Register views and use focus instead
        @track_controller.table.events.trigger(:key, key)
      end
    end

    def stop
      @stop = true
    end

    def stop?
      @stop == true
    end

  end
end
