require_relative 'ext/mpg123'
require 'ffi-portaudio'
include FFI::PortAudio

filename = "/Users/soundcloud/01.mp3"

Mpg123.init
mp3 = Mpg123.new(filename)
puts mp3.length

process = lambda do |input, output, frames, time_info, status, _|
  slice = mp3.read(frames * 2)
  output.write_array_of_float(slice)
  :paContinue
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

FFI::PortAudio::API.Pa_Initialize
stream = FFI::Buffer.new(:pointer)

API.Pa_OpenStream(
  stream,
  nil,
  stream_parameters,
  44100,
  4096,
  API::NoFlag,
  process,
  nil)

API.Pa_StartStream(stream.read_pointer)

sleep 30
