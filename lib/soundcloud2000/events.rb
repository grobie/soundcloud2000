module Soundcloud2000
  class Events
    def initialize
      @handlers = Hash.new { |h, k| h[k] = [] }
    end

    def on(event, &block)
      @handlers[event] << block
    end

    def trigger(event, *args)
      @handlers[event].each do |handler|
        handler.call(*args)
      end
    end
  end
end
