require 'open3'

module AudioPlayer
  class AudioBuffer
    attr_reader :buffer

    def initialize(url)
      @buffer = []
      @url = url
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
        read_from_process!
      end

      @buffer[start, length]
    end

    def read_from_process!
      buffer = @in.read(2**12 * 4)
      @buffer.concat(buffer.unpack('g*'))
    end

    def size
      @buffer.size
    end
  end
end


if __FILE__ == $0
  buffer = AudioPlayer::AudioBuffer.new('http://localhost:8000/01.mp3')
  buffer.start
  buffer.read(44_100 * 2 * 160, 4096)
  puts buffer.size / (44_100 * 2)
end
