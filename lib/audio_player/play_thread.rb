module AudioPlayer
  class PlayThread
    def initialize(output_buffer, audio_buffer)
      @output_buffer = output_buffer
      @audio_buffer = audio_buffer
      @position = 0
    end

    def start_thread!
      Thread.start do
        begin
          sleep 0.1 while @audio_buffer.size < 50

          loop do
            if @position < @audio_buffer.size
              @output_buffer << @audio_buffer[@position]
              @position += 1
            end
          end
        rescue => e
          p self
          p e
          puts e.backtrace
        end
      end
    end

    def kill
      @thread.kill
    end

    def rewind
      @position -= 50
      @position = [@position, 0].max
    end

    def forward
      @position += 50
      @position = [@position, @audio_buffer.size - 1].min
    end

    def start
      @thread ||= start_thread!
      @output_buffer.start
    end

    def stop
      @output_buffer.stop
    end
  end
end
