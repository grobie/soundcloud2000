require "fftw3"
require 'ffi-portaudio'

module AudioPlayer
  class PlayThread
    include FFI::PortAudio

    SKIP_SAMPLES = 44_100 * 2

    def initialize(logger, audio_buffer, &callback)
      @logger = logger
      @audio_buffer = audio_buffer
      @callback = callback
      @position = 0
      @stream = FFI::Buffer.new(:pointer)
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
      log :open_stream
      log API.Pa_OpenStream(
        @stream,
        nil,
        stream_parameters,
        44100,
        2**12,
        API::NoFlag,
        method(:process),
        nil)
    end

    def log(s)
      @logger.debug("PlayThread #{s}")
    end

    def process(input, output, frames, time_info, status, _)
      b = @audio_buffer.read(@position, frames * 2)
      output.write_array_of_float(b)
      @position += frames * 2
      :paContinue
    end

    def start_stream
      log :start_stream
      log API.Pa_StartStream(@stream.read_pointer)
    end

    def start
      open_stream
      start_stream
    end

    def stop
      log :stop
    end

      # fft = FFTW3.fft(slice, 1, 0) / slice.length
      # spectrum = (1..100).map {|i| fft[i * 20].abs }
      # @callback.call(@position, @audio_buffer.size, spectrum)

    def rewind
      @position -= SKIP_SAMPLES
      @position = [@position, 0].max
      log "rewind to #{@position}"
    end

    def forward
      @position += SKIP_SAMPLES
      @position = [@position, @audio_buffer.size - 1].min
      log "forward to #{@position}"
    end
  end
end
