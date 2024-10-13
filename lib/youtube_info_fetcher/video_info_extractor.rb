# frozen_string_literal: true

module YouTubeInfoFetcher
  class VideoInfoExtractor
    def extract(data)
      return unless data && data['items'] && !data['items'].empty?

      snippet = data['items'].first['snippet']
      {
        title: snippet['title'],
        published_at: snippet['publishedAt'],
        channel_title: snippet['channelTitle'],
        description: snippet['description'],
        thumbnail_url: snippet['thumbnails']['high']['url']
      }
    end
  end
end

