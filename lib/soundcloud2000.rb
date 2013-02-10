
require_relative 'soundcloud2000/client'
require_relative 'soundcloud2000/application'

module Soundcloud2000
  CLIENT_ID = '29f8e018e1272c27bff7d510a10da2a8'

  def self.start
    client = Client.new(CLIENT_ID)
    application = Application.new(client)

    Signal.trap('SIGINT') do
      application.stop
    end

    application.run
  end

end
