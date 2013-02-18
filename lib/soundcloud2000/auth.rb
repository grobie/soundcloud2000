module Soundcloud2000
  class Auth
    def initialize(credentials, client_id)
      @username, @password = credentials
      @client_id = client_id
    end

    def options
      {
        client_id: @client_id,
        redirect_uri: 'http://developers.soundcloud.com/callback.html',
        state: "SoundCloud_Dialog_#{token}",
        response_type: 'code_and_token',
        scope: 'non-expiring',
        display: 'popup'
      }
    end

    def authenticate
      uri_params = URI.escape(options.collect{|k,v| "#{k}=#{v}"}.join('&'))

      # need to fake the login window
      login_window_request = Net::HTTP::Get.new("/connect?#{uri_params}")
      login_window_result = request(login_window_request)

      # login with username and password
      login_request = Net::HTTP::Post.new("/connect/login")
      login_request.set_form_data(options.merge(username: @username,
                                                password: @password))
      login_result = request(login_request)

      if login_result.code == '302'
        access_token = login_result.body.match(/access_token=(.*)&amp/)[1]
      else
        puts "an error occured during authentication, please try again later"
      end
    end

    def authenticate_and_save
      save(authenticate)
    end

    def save(access_token)
      return if access_token.nil?
      File.open(AUTH_FILE, 'w') { |f| f.write(JSON.dump({access_token: access_token})) }
    end

    def token
      @token ||= rand(1000000).to_s(16)
    end

    def request(request)
      Net::HTTP.start('soundcloud.com', 443, use_ssl: true) do |http|
        http.request(request)
      end
    end

    def self.access_token
      JSON.parse(File.read(AUTH_FILE))["access_token"]
    end
  end
end
