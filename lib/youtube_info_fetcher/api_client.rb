# frozen_string_literal: true

require 'http'
require 'json'

module YouTubeInfoFetcher
  class ApiClient
    def initialize(api_key)
      @api_key = api_key
    end

    def fetch_video_data(video_id)
      url = youtube_api_path(video_id)
      response = HTTP.headers('Accept' => 'application/json').get(url)
      return handle_request_error(response) unless response.status.success?

      response.parse(:json)
    rescue JSON::ParserError => e
      puts "JSON parsing error: #{e.message}"
      nil
    end

    private

    def youtube_api_path(video_id)
      "https://www.googleapis.com/youtube/v3/videos?id=#{video_id}&key=#{@api_key}&part=snippet"
    end

    def handle_request_error(response)
      puts "request_error: #{response.status}"
      nil
    end
  end
end