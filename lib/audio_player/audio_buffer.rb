require 'coreaudio'

module AudioPlayer
  class AudioBuffer
    def initialize(logger, file_path)
      @logger = logger
      @file_path = file_path
      @file = CoreAudio::AudioFile.new(file_path, :read)
      @slices = []
    end

    def log(s)
      @logger.debug("AudioBuffer #{s}")
    end

    def close
      @file.close
    end
    def downloaded_slices
      (File.size(@file_path) - 52) / 372
    end

    def read
      Thread.start do
        log :thread_start
        begin
          loop do
            sleep 0.1 while downloaded_slices < @slices.size

            if buf = @file.read(1024)
              @slices << buf
            else
              break
            end
          end
          log "finished #{@slices.size} of #{downloaded_slices}"
        rescue => e
          log e.message
        end
      end

      self
    end

    def [](i)
      @slices[i]
    end

    def size
      @slices.size
    end
  end
end
