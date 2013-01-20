module AudioPlayer
  class PlayThread
    def initialize(logger, output_buffer, audio_buffer, &callback)
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
          sleep 0.1 while @audio_buffer.size == 0
          log :playing

          loop do
            if @position < @audio_buffer.size
              @output_buffer << @audio_buffer[@position]
              @callback.call(@position, @audio_buffer.size)
              @position += 1
            end
          end

          log :stopped_running
        rescue => e
          log e.message
        end
      end
    end

    def kill
      log :kill
      @thread.kill if @thread
      @audio_buffer.close
      @output_buffer.stop
    end

    def rewind
      @position -= 50
      @position = [@position, 0].max
      log "rewind to #{@position}"
    end

    def forward
      @position += 50
      @position = [@position, @audio_buffer.size - 1].min
      log "forward to #{@position}"
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
