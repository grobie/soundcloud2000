require 'logger'

require_relative 'ui/canvas'
require_relative 'ui/input'
require_relative 'controllers/track_controller'
require_relative 'controllers/player_controller'
require_relative 'controllers/splash_controller'

module Soundcloud2000
  class Application

    def initialize(client)
      @logger = Logger.new('debug.log')
      @canvas = UI::Canvas.new
      @player_controller = Controllers::PlayerController.new(@logger, client, 10, Curses.cols, 0, 0)
      @track_controller = Controllers::TrackController.new(client, 10)
      @splash_controller = Controllers::SplashController.new
      @track_controller.events.on(:select) do |track|
        @player_controller.play(track)
      end
    end

    def main
      loop do
        if @workaround_was_called_once_already
          handle UI::Input.get(-1)
        else
          @workaround_was_called_once_already = true
          handle UI::Input.get(0)
          @track_controller.render
        end

        break if stop?
      end
    ensure
      @canvas.close
    end

    def run
      @splash_controller.render
      main
    end

    # TODO: look at active controller and send key to active controller instead
    def handle(key)
      case key
      when :left, :right, :space, :s
        @player_controller.events.trigger(:key, key)
      when :down, :up, :enter, :u
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
