# Class to handle YouTube API interactions

require 'google/apis/youtube_v3'

module TitleTOC
  class YouTubeAPI
    YOUTUBE_API_KEY = 'YOUR_YOUTUBE_API_KEY'

    def initialize
      @youtube = Google::Apis::YoutubeV3::YouTubeService.new
      @youtube.key = YOUTUBE_API_KEY
    end

    def fetch_playlist_info(playlist_id)
      playlist_response = @youtube.list_playlists('snippet', id: playlist_id)
      playlist_title = playlist_response.items.first.snippet.title

      video_titles = fetch_video_titles(playlist_id)

      { playlist_title: playlist_title, video_titles: video_titles }
    end

    private

    def fetch_video_titles(playlist_id)
      video_titles = []
      next_page_token = nil

      begin
        response = @youtube.list_playlist_items('snippet', playlist_id: playlist_id, max_results: 50, page_token: next_page_token)
        video_titles.concat(response.items.map { |item| item.snippet.title })
        next_page_token = response.next_page_token
      end while next_page_token

      video_titles
    end
  end