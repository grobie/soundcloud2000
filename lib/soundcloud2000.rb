require_relative 'soundcloud2000/client'
require_relative 'soundcloud2000/application'

module Soundcloud2000
  CLIENT_ID     = '29f8e018e1272c27bff7d510a10da2a8'
  CLIENT_SECRET = 'MY_SECRET'
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

  def self.refresh_token
    client = Client.new(CLIENT_ID)

    if File.exist?(AUTH_FILE)
      auth = JSON.parse(File.read(AUTH_FILE))

      opts = { client_secret: CLIENT_SECRET, grant_type: 'refresh_token',
               refresh_token: auth["refresh_token"] }

      res = client.post('/oauth2/token', opts)
      File.open(AUTH_FILE, 'w') { |file| file.write(JSON.dump(res)) }
    end
  end

  def self.auth(credentials)
    username, password = credentials

    client = Client.new(CLIENT_ID)
    opts = {  client_secret: CLIENT_SECRET, grant_type: 'password',
              username: username, password: password }

    res = client.post('/oauth2/token', opts)
    File.open(AUTH_FILE, 'w') { |file| file.write(JSON.dump(res)) }
  end

end
