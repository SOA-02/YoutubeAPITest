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
        CHANNELS_PATH = 'https://www.googleapis.com/youtube/v3'

        def initialize(api_key)
          @api_key = api_key
        end

        def yt_channel_path(video_id)
          get(CHANNELS_PATH + "/videos?id=#{video_id}&key=#{@api_key}&part=snippet")
        end

        def yt_playlist_path(playlist_id, api_key)
          "#{YT_API_ROOT}/playlists?id=#{playlist_id}&key=#{api_key}&part=snippet"
        end

        def yt_video_path(video_id, api_key)
          "#{YT_API_ROOT}/videos?id=#{video_id}&key=#{api_key}&part=snippet"
        end

        def get(url)
          puts("先確認是否正確#{url}")
          http_response = HTTP.headers('Accept' => 'application/json').get(url)

          Response.new(http_response).tap do |response|
            raise(response.error) unless response.successful?
          end
        end
      end

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
