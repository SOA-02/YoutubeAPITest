# frozen_string_literal: true

# Represents channel information for YouTube API.
module Outline
  # Your class implementation...
  class ChannelInfo
    def initialize(video_info)
      @video_info = video_info['snippet']
    end

    def title
      @video_info['title']
    end

    def published_at
      @video_info['publishedAt']
    end

    def channel_title
      @video_info['channelTitle']
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
