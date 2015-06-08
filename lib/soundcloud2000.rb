require_relative 'soundcloud2000/client'
require_relative 'soundcloud2000/application'
require_relative 'soundcloud2000/auth'

module Soundcloud2000
  CLIENT_ID     = '29f8e018e1272c27bff7d510a10da2a8'
  APP_FOLDER    = File.expand_path("~/.soundcloud2000")
  AUTH_FILE     = File.join(APP_FOLDER, 'auth.json')

  def self.start
    client = Client.new(CLIENT_ID)
    application = Application.new(client)

    Signal.trap('SIGINT') do
      application.stop
    end

    application.run
  end

  def self.authenticate(credentials)
    auth = Soundcloud2000::Auth.new(credentials, CLIENT_ID)
    auth.authenticate_and_save
  end
end
