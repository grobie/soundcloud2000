require_relative 'elements/canvas'
require_relative 'views/track_view'
require_relative 'input'

module Soundcloud2000
  class Application

    def initialize(client)
      @canvas = Elements::Canvas.new
      @track_view = Views::TrackView.new(client)
      @canvas.add @track_view
    end

    def run
      loop do
        handle Input.get(100)
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
