require_relative 'elements/canvas'
require_relative 'elements/table'

module Soundcloud2000
  class Application

    def initialize(client)
      @client = client
      @canvas = Elements::Canvas.new
      @tracks = client.tracks

      @table = Elements::Table.new
      @table.header 'Title', 'User', 'Length'
      @table.body *@tracks[0..5].map { |track| [ track.title, track.user.username, track.duration.to_s ] }

      @canvas.add @table
    end

    def run
      loop do
        @canvas.draw
        sleep(1)

        # example. not really necessary though ...
        unless @i_was_here_already
          @i_was_here_already = true
          @table.body *@tracks.map { |track| [ track.title, track.user.username, track.duration.to_s ] }
        end

        break if stop?
      end
    ensure
      @canvas.close
    end

    def stop
      @stop = true
    end

    def stop?
      @stop == true
    end

  end
end
