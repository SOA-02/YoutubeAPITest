# frozen_string_literal: true

module Outline
  # Provides access to video data
  class Video
    def initialize(video_data, youtube_api)
      @video_info = video_data['snippet']
      @youtube_api = youtube_api
    end

    def title
      @video_info['title']
    end

    def published_at
      @video_info['publishedAt']
    end

    def description
      @video_info['description']
    end

    def thumbnail_url
      @video_info['thumbnails']['high']['url']
    end

    def tags
      @video_info['tags']
    end
  end
end
