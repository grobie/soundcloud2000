require 'fftw3'
require 'ffi-portaudio'
require 'json'

require_relative 'audio_buffer'

module AudioPlayer
  class PlayerProcess
    include FFI::PortAudio

    SKIP_SAMPLES = 44_100 * 2

    attr_reader :position

    def initialize(logger, &callback)
      @logger = logger
      @callback = callback
      @position = 0
      open_stream
    end

    def stream_parameters
      output = API::PaStreamParameters.new
      output[:device] = API.Pa_GetDefaultOutputDevice
      output[:suggestedLatency]= API.Pa_GetDeviceInfo(output[:device])[:defaultHighOutputLatency]
      output[:hostApiSpecificStreamInfo] = nil
      output[:channelCount] = 2
      output[:sampleFormat] = API::Float32
      output
    end

    def open_stream
      FFI::PortAudio::API.Pa_Initialize
      @stream = FFI::Buffer.new(:pointer)
      API.Pa_OpenStream(
        @stream,
        nil,
        stream_parameters,
        44100,
        2**12,
        API::NoFlag,
        method(:process),
        nil)
    end

    def read_commands_from(input)
      while line = input.gets
        send(*JSON.parse(line))
      end
    end

    def send!(*args)
      # TODO for some reason Open3.popen3 cannot read STDOUT
      # so use STDERR as a workaround
      STDERR.puts args.to_json
    end

    def position=(position)
      @position = position
      @position = [@position, 0].max

      # TODO check for end of track
      # @position = [@position, @buffer.size - 1].min

      send! :on_position_change, @position
    end

    def process(input, output, frames, time_info, status, _)
      slice = @buffer.read(position, frames * 2)
      render_spectrum(position, frames * 2)
      puts slice.size

      if slice.size == frames * 2
        output.write_array_of_float(slice)
        self.position += slice.size
        :paContinue
      end

    rescue EOFError
      :paComplete
      send! :on_complete
    rescue => e
      puts e.message
      puts e.backtrace
    end

    def start_stream
      if API.Pa_IsStreamStopped(@stream.read_pointer)
        API.Pa_StartStream(@stream.read_pointer)
      end
    end

    def stop_stream
      if API.Pa_IsStreamActive(@stream.read_pointer)
        API.Pa_StopStream(@stream.read_pointer)
      end
    end

    def abort_stream
      API.Pa_AbortStream(@stream.read_pointer)
    end

    def load(url)
      @position = 0
      @buffer = AudioBuffer.new(url)
      @buffer.start
    end

    def render_spectrum(pos, length)
      slice = NArray.to_na(@buffer.read(pos, length))
      fft = FFTW3.fft(slice, -1)
      spectrum = (1..80).map {|i| fft[i * 20].abs }
      send! :on_spectrum, spectrum
    end

    def rewind
      self.position -= SKIP_SAMPLES
    end

    def forward
      self.position += SKIP_SAMPLES
    end
  end
end

if __FILE__ == $0
  require 'logger'
  player = AudioPlayer::PlayerProcess.new(STDERR)
  player.load("http://localhost:8000/01.mp3")
  player.position = 44_100 * 2 * 120
  player.start_stream
  gets
end
