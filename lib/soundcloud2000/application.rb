require_relative 'ui/canvas'
require_relative 'ui/input'
require_relative 'views/track_view'

module Soundcloud2000
  class Application

    def initialize(client)
      @canvas = UI::Canvas.new
      @track_view = Views::TrackView.new(client)
      @canvas.add @track_view
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
      when :down, :up
        @track_view.send(key)
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
