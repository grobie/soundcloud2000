require_relative 'controller'
require_relative '../ui/splash'

module Soundcloud2000
  module Controllers
    class SplashController < Controller

      def initialize(height = nil, width = nil, x = nil, y = nil)
        super
        @view = UI::Splash.new
      end

      def process
        @view.render
      end

    end
  end
end