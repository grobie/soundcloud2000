require 'logger'

require_relative 'ui/canvas'
require_relative 'ui/input'
require_relative 'controllers/track_controller'
require_relative 'controllers/player_controller'

module Soundcloud2000
  class Application

    def initialize(client)
      @logger = Logger.new('debug.log')
      @canvas = UI::Canvas.new
      @player_controller = Controllers::PlayerController.new(@logger, client, 10, Curses.cols, 0, 0)
      @track_controller = Controllers::TrackController.new(client, 10)
      @track_controller.events.on(:select) do |track|
        @player_controller.play(track)
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

    # TODO: look at active controller and send key to active controller instead
    def handle(key)
      case key
      when :left, :right, :space
        @player_controller.events.trigger(:key, key)
      when :down, :up, :enter
        @track_controller.events.trigger(:key, key)
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
