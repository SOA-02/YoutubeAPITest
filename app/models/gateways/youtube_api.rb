# frozen_string_literal: true

require 'http'
require 'yaml'

module Outline
  # Represents interactions with the YouTube API.
  module Youtube
    class YoutubeApi
      def initialize(api_key)
        @api_key = api_key
      end

      def channel_info(video_id)
        Request.new(@api_key).yt_channel_path(video_id).parse
      end

      # Sends out HTTP requests to Youtube
      class Request
        YT_API_ROOT = 'https://www.googleapis.com/youtube/v3'

        def initialize(api_key)
          @api_key = api_key
        end

        def yt_channel_path(channel_id)
          get(YT_API_ROOT + "/channels?id=#{channel_id}&key=#{@api_key}&part=snippet")
        end

        def yt_playlist_path(playlist_id)
          get(YT_API_ROOT + "/playlists?id=#{playlist_id}&key=#{@api_key}&part=snippet")
        end

        def yt_video_path(video_id)
          get(YT_API_ROOT + "/videos?id=#{video_id}&key=#{@api_key}&part=snippet")
        end

        def get(url)
          puts("先確認是否正確#{url}")
          http_response = HTTP.headers('Accept' => 'application/json').get(url)

          Response.new(http_response).tap do |response|
            raise(response.error) unless response.successful?
          end
        end
      end

      # Decorates HTTP::Response with success and error methods.
      class Response < SimpleDelegator
        NotFound = Class.new(StandardError)
        HTTP_ERROR = {
          404 => NotFound
        }.freeze

        def successful?
          HTTP_ERROR.keys.none?(code)
        end

        def error
          HTTP_ERROR[code]
        end
      end
    end
  end
end

# Example usage:
config = YAML.load_file(File.expand_path('../../../config/secrets.yml', __dir__))
api_key = config['YT_TOKEN']
video_id = 'jeqH4eMGjhY'
channel_id = 'UCMUnInmOkrWN4gof9KlhNmQ'

youtube_api = Outline::Youtube::YoutubeApi.new(api_key)
channel_info = youtube_api.channel_info(channel_id)
#video_info = youtube_api.video_info(video_id)
puts "Channel Info: #{channel_info}"
