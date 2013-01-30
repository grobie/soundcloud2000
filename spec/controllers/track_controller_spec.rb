require_relative '../spec_helper'
require_relative '../../lib/soundcloud2000/controllers/track_controller'

module Soundcloud2000
  module Controllers
    describe TrackController do
      let(:tracks) { mock }
      let(:table)  { mock }
      let(:client) { mock }

      subject { TrackController.new(table, client) }

      before do
        table.expects(:bind_to)

        subject.bind_to(tracks)
      end

      it 'on key enter' do
        table.expects(:select)
        table.expects(:current).returns(mock)
        tracks.expects(:[]).returns(mock)

        subject.events.trigger(:key, :enter)
      end

      it 'on key up' do
        table.expects(:up)

        subject.events.trigger(:key, :up)
      end

      it 'on key down' do
        table.expects(:down)
        table.expects(:bottom?).returns(true)
        tracks.expects(:load_more)

        subject.events.trigger(:key, :down)
      end

      it 'on key u' do
        UI::Input.expects(:getstr).returns(:permalink)
        client.expects(:resolve).returns(:user)
        tracks.expects(:user=)

        subject.events.trigger(:key, :u)
      end
    end
  end
end
