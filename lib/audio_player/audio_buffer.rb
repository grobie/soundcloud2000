require 'open3'

module AudioPlayer
  class AudioBuffer
    attr_reader :buffer

    def initialize(logger, url)
      @logger = logger
      @buffer = []
      @url = url
    end

    def log(s)
      @logger.debug("AudioBuffer #{s}")
    end

    def close
      @io.close
    end

    def start
      cmd = ['ffmpeg', '-loglevel', 'quiet', '-i', @url, '-f', 'f32be', '-acodec', 'pcm_f32be', '-'];
      @out, @in, @err, @wait = Open3.popen3(*cmd)
    end

    def read(start, length)
      while @buffer.size < (start + length)
        return false if not read_from_process
      end

      @buffer[start, length]
    end

    def read_from_process
      if b = @in.read(2**12)
        @buffer.concat(b.unpack('g*'))
        true
      else
        false
      end
    end

    def size
      @buffer.size
    end
  end
end


if __FILE__ == $0
  require 'logger'

  buffer = AudioPlayer::AudioBuffer.new(Logger.new(STDOUT), 'http://localhost:8000/01.mp3')

  buffer.start
  sleep 5
  p buffer.buffer
end
