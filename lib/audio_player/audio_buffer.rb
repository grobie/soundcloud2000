require 'coreaudio'

module AudioPlayer
  class AudioBuffer
    def initialize(logger, file_path)
      @logger = logger
      @file = CoreAudio::AudioFile.new(file_path, :read)
      @frames = []
    end

    def log(s)
      @logger.debug("AudioBuffer #{s}")
    end

    def read
      Thread.start do
        log :thread_start
        begin
          while buf = @file.read(1024)
            @frames << buf
            log "frames = #{@frames.size}"
          end
        rescue => e
          log e.message
        end
      end

      self
    end

    def [](i)
      @frames[i]
    end

    def size
      @frames.size
    end
  end
end
