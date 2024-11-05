# frozen_string_literal: true

require_relative 'video'

module Views
  # View for a a list of video entities
  class VideosList
    def initialize(videos)
      @videos = videos.map.with_index { |vid, i| Video.new(vid, i) }
    end

    def each(&show)
      @videos.each do |vid|
        show.call vid
      end
    end

    def any?
      @videos.any?
    end
  end
end