require_relative 'soundcloud2000/client'
require_relative 'soundcloud2000/application'
require_relative 'soundcloud2000/elements/table'

module Soundcloud2000

  def self.start
    client = Client.new
    application = Application.new

    application.run do
      table = Elements::Table.new
      table.header 'soundcloud2000'
      table.body *client.tracks.map { |track| [ track.title, track.user.username ] }
      table.draw
    end
  end

end
