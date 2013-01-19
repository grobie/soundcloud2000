require_relative 'soundcloud2000/client'

module Soundcloud2000

  def self.start
    client = Client.new

    puts 'soundcloud2000'
    puts '=============='

    client.tracks.each do |track|
      puts [track.title, track.user.username].join("\t")
    end
  end

end
