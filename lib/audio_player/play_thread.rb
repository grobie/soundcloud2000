module AudioPlayer
  class PlayThread
    def initialize(logger, output_buffer, audio_buffer, callback)
      @logger = logger
      @output_buffer = output_buffer
      @audio_buffer = audio_buffer
      @callback = callback
      @position = 0
    end

    def log(s)
      @logger.debug("PlayThread #{s}")
    end

    def start_thread!
      @thread = Thread.start do
        begin
          log :thread_start
          sleep 0.1 while @audio_buffer.size < 50
          log :prebuffered

          loop do
            if @position < @audio_buffer.size
              log "position = #@position"
              @output_buffer << @audio_buffer[@position]
              @callback.call(@position, @audio_buffer.size)
              @position += 1
            end
          end
        rescue => e
          log e.message
        end
      end
    end

    def kill
      log :kill
      @stop
      @thread.kill if @thread
    end

    def rewind
      log :rewind
      @position -= 50
      @position = [@position, 0].max
    end

    def forward
      log :forward
      @position += 50
      @position = [@position, @audio_buffer.size - 1].min
    end

    def start
      log :start
      @thread ||= start_thread!
      @output_buffer.start
    end

    def stop
      log :stop
      @output_buffer.stop
    end
  end
end
