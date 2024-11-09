# frozen_string_literal: true

module Views
  # View for a single video entity
  class Video
    def initialize(video, index = nil)
      @video = video
      @index = index
    end

    def entity
      @video
    end

    def praise_link
      "/outline/#{@video.video_id}"
    end

    def index_str
      "video[#{@index}]"
    end

    def http_url
      @video.video_id
    end

    def id
      @video.video_id
    end

    def title
      @video.video_title
    end

    def description
      @video.video_description
    end
    
    def published_at
      @video.video_published_at
    end
  end
end
