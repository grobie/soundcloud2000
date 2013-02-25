require_relative '../ui/table'

module Soundcloud2000
  module Views
    class TracksTable < UI::Table
      def initialize(*args)
        super
        self.header = ['Title', 'User Link', 'User Name', 'Length', 'Plays', 'Likes', 'Comments']
        self.keys   = [:title, :permalink, :username, :length, :plays, :likes, :comments]
      end
    end
  end
end
