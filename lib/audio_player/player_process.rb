require 'fftw3'
require 'ffi-portaudio'
require 'json'
require_relative '../../ext/mpg123'

module AudioPlayer
  class PlayerProcess
    include FFI::PortAudio

    SKIP_SECONDS = 1

    attr_reader :position

    def initialize(logger)
      @logger = logger
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
      Mpg123.init
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

    def load(file)
      @mp3 = Mpg123.new(file)
    end

    def time_per_frame
      @mp3.tpf
    end

    def samples_per_frame
      @mp3.spf
    end

    def tell
      @mp3.tell
    end

    def length
      @mp3.length
    end

    def read(samples)
      @mp3.read(samples)
    end

    def seconds_to_frames(seconds)
      seconds / time_per_frame
    end

    def seconds_to_samples(seconds)
      seconds_to_frames(seconds) * samples_per_frame
    end

    def samples_to_seconds(samples)
      samples_to_frames(samples) * time_per_frame
    end

    def samples_to_frames(samples)
      samples / samples_per_frame
    end

    def seek(seconds)
      samples = seconds_to_samples(seconds)

      if (0..length).include?(samples)
        @mp3.seek(samples)
        send! :on_position_change, position
      end
    end

    def position
      samples_to_seconds(tell)
    end

    def process(input, output, samples, time_info, status, _)
      if tell == length
        output.write_array_of_float((0..samples).map { 0 })
        send! :on_complete
        API.Pa_Sleep(1000)
      elsif slice = read(samples * 2)
        send! :on_level, level(slice)
        send! :on_position_change, position

        output.write_array_of_float(slice)
      else
        output.write_array_of_float((0..samples).map { 0 })
      end

      :paContinue
    rescue => e
      puts e.message
      puts e.backtrace
    end

    def start_stream
      unless @active
        @active = true
        API.Pa_StartStream(@stream.read_pointer)
      end
    end

    def stop_stream
      if @active
        @active = false
        API.Pa_StopStream(@stream.read_pointer)
      end
    end

    def level(slice)
      slice.inject(0) {|s, i| s + i.abs } / slice.size
    end

    def rewind
      if @mp3
        start_stream
        seek(position - SKIP_SECONDS)
      end
    end

    def forward
      if @mp3
        start_stream
        seek(position + SKIP_SECONDS)
      end
    end
  end
end

if __FILE__ == $0
  require 'logger'
  filename = "/Users/soundcloud/01.mp3"
  player = AudioPlayer::PlayerProcess.new(STDERR)
  player.load(filename)
  player.start_stream
  player.seek(170)
  gets
end
