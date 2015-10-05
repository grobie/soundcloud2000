require_relative 'soundcloud2000/client'
require_relative 'soundcloud2000/application'

module Soundcloud2000

  def self.start
    unless CLIENT_ID = ENV['SC_CLIENT_ID']
      puts "You need to set SC_CLIENT_ID to a valid client ID"
      exit 1
    end

    client = Client.new(CLIENT_ID)
    application = Application.new(client)

    Signal.trap('SIGINT') do
      application.stop
    end

    application.run
  end

end
