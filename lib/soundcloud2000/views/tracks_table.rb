require_relative '../ui/table'

module Soundcloud2000
  module Views
    # this view is responsible for the bar that separates the player and track list
    class TracksTable < UI::Table
      def initialize(*args)
        super
        self.header = %w(Title User Length Plays Likes Comments)
        self.keys   = [:title, :username, :length, :plays, :likes, :comments]
      end
    end
  end
end
