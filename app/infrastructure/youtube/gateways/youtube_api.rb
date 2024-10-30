# frozen_string_literal: true

require 'http'
require 'yaml'

module Outline
  # Represents interactions with the YouTube API.
  module Youtube
    # Library for Youtube Web API
    class YoutubeApi
      def initialize(api_key)
        @api_key = api_key
      end

      def channel_data(channel_id)
        Request.new(@api_key).yt_channel_path(channel_id).parse
      end

      def video_info(video_id)
        Request.new(@api_key).yt_video_path(video_id).parse
      end

      def playlist_data(playlist_id)
        Request.new(@api_key).yt_playlist_path(playlist_id).parse
      end

      # Sends out HTTP requests to Youtube
      class Request
        YT_API_ROOT = 'https://www.googleapis.com/youtube/v3'

        def initialize(api_key)
          @api_key = api_key
        end

        def channel_data(channel_id)
          Request.new(@api_key).yt_channel_path(channel_id).parse
        end

        def yt_channel_path(channel_id)
          # https://www.googleapis.com/youtube/v3/search?part=snippet&type=channel&q=VantacrowBringer&key="
          get(YT_API_ROOT + "/channels?part=snippet%2CcontentDetails%2Cstatistics&id=#{channel_id}&key=#{@api_key}")
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

      # Decorates HTTP responses from Youtube with success/error

      class Response < SimpleDelegator # rubocop:disable Style/Documentation
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
