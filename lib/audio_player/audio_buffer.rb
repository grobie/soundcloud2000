require 'coreaudio'

module AudioPlayer
  class AudioBuffer
    def initialize(file_path)
      @file = CoreAudio::AudioFile.new(file_path, :read)
      @frames = []
    end

    def read
      Thread.start do
        begin
          while buf = @file.read(1024)
            @frames << buf
          end
        rescue => e
          p self
          p e
          puts e.backtrace
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
